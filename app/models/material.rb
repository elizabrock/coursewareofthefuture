require 'materiable'

class Material
  include Materiable

  attr_accessor :children, :local_id
  @@LAST_ID = 0

  INSTRUCTOR_NOTES_PATTERN = /instructor_notes/
  EXERCISE_PATTERN = /[Ee]xercises/
  ROOT = "."

  def initialize(item = nil)
    @children = []
    @item = item
    # To help with unique IDs when rendering views
    @@LAST_ID += 1
    @local_id = @@LAST_ID
  end

  def self.exercises(client, repository)
    exercises = client.tree(repository, "master", recursive: true).tree
    exercises = exercises.find_all{ |item| item[:path].match(EXERCISE_PATTERN) && !item[:path].match(INSTRUCTOR_NOTES_PATTERN) }
    exercises = exercises.map{ |item| Material.new(item) }
    exercises = exercises.find_all{ |item| item.exercise? and item.markdown? }
    exercises
  end

  def self.list(client, repository, directory)
    contents = client.contents(repository, path: directory)
    contents.map{ |item| Material.new(item) }
  end

  def self.materials(client, repository)
    root = Material.new()
    tree = client.tree(repository, "master", recursive: true).tree
    materials = tree.map{ |tree_item| Material.new(tree_item) }
    materials = materials.reject{ |m| m.fullpath.match(EXERCISE_PATTERN) or m.fullpath.match(INSTRUCTOR_NOTES_PATTERN) }
    materials.each do |material|
      parent = root.find(material.directory)
      parent.incorporate_child(material)
    end
    root
  end

  def self.retrieve(filepath, repository, client)
    begin
      result = client.contents(repository, path: filepath)
      Material.new(result)
    rescue Octokit::Forbidden # For Binary files
      directory = File.dirname(filepath)
      sibling_materials = Material.list(client, repository, directory)
      material = sibling_materials.find{|material| material.fullpath == filepath}
      blob = client.blob(repository, material.sha)
      blob.path = filepath
      Material.new(blob)
    end
  end

  def incorporate_child(child)
    return unless child.directory? or (child.markdown? and !child.exercise?)
    self.children << child
  end

  def content
    Base64.decode64(@item.content) if @item.content.present?
  end

  def descendants
    all_descendants = @children + @children.map(&:descendants)
    all_descendants.flatten.sort_by!{ |m| m.formatted_title }
  end

  def directory
    @directory ||= File.dirname(self.fullpath)
  end

  def directory?
    @item.type == "tree"
  end

  def exercise?
    @item.path.match(EXERCISE_PATTERN)
  end

  def find(path)
    return self if self.filename == path or path.blank?

    subdirectory, remaining_path = path.split("/", 2)
    matching_child = self.children.find{ |c| c.filename == subdirectory }
    matching_child.find(remaining_path)
  end

  def find_by_filename(filename)
    result = self.children.find{ |c| c.filename == filename }
    return result if result
    self.children.each do |child|
      result = child.find_by_filename(filename)
      return result if result
    end
    nil
  end

  def filename
    @filename ||= File.basename(self.fullpath)
  end

  def fullpath
    @fullpath ||= @item.try(:path) || ROOT
  end

  def html_url
    @item.html_url
  end

  def leaf?
    self.children.empty?
  end

  def self.prettify(name)
    name.titleize.
      gsub(/^\d\d\s/, "").
      gsub("To", "to").
      gsub("And", "and").
      gsub("Erb", "ERB").
      gsub("Actionview", "ActionView")
  end

  def sha
    @item.sha
  end

  def to_hash
    child_hash_array = []
    self.children.each do |child|
      child_hash_array << child.to_hash
    end
    return child_hash_array if self.fullpath == ROOT
    hash = { title: formatted_title }
    hash[:path] = fullpath if markdown?
    hash[:children] = child_hash_array unless child_hash_array.empty?
    hash
  end

  def to_param
    fullpath
  end

  protected

  def item
    @item
  end
end

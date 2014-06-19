class Material
  attr_accessor :children, :local_id
  @@LAST_ID = 0

  ROOT = "."

  def initialize(item = nil)
    @children = []
    @item = item
    # To help with unique IDs when rendering views
    @@LAST_ID += 1
    @local_id = @@LAST_ID
  end

  def self.list(client, repository, directory)
    contents = client.contents(repository, path: directory)
    contents.map{ |item| Material.new(item) }
  end

  def self.retrieve(filepath, repository, client)
    begin
      result = client.contents(repository, path: filepath)
      Material.new(result)
    rescue Octokit::Forbidden
      directory = File.dirname(filepath)
      sibling_materials = Material.list(client, repository, directory)
      material = sibling_materials.find{|material| material.fullpath == filepath}
      blob = client.blob(repository, material.sha)
      blob.path = filepath
      Material.new(blob)
    end
  end

  def self.root(client, repository, skip_files_matching)
    root = Material.new()
    tree = client.tree(repository, "master", recursive: true).tree
    materials = tree.map{ |tree_item| Material.new(tree_item) }
    materials.each do |material|
      insert_into_tree(material, root, skip_files_matching)
    end
    root
  end

  def incorporate_child(child)
    return unless child.markdown? or child.directory?
    self.children << child
  end

  def content
    Base64.decode64(@item.content) if @item.content.present?
  end

  def descendants
    all_descendants = @children + @children.map(&:descendants)
    all_descendants.flatten.sort_by!{ |m| m.pretty_name }
  end

  def directory
    @directory ||= File.dirname(self.fullpath)
  end

  def directory?
    @item.type == "tree"
  end

  def extension
    File.extname(self.fullpath)
  end

  def find(path)
    return self if self.filename == path or path.blank?

    subdirectory, remaining_path = path.split("/", 2)
    matching_child = self.children.find{ |c| c.filename == subdirectory }
    matching_child.find(remaining_path)
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

  def markdown?
    extension == ".md"
  end

  def link
    "materials/" + self.fullpath if self.markdown?
  end

  def self.prettify(name)
    name.titleize.
      gsub(/^\d\d\s/, "").
      gsub("To", "to").
      gsub("And", "and").
      gsub("Erb", "ERB").
      gsub("Actionview", "ActionView")
  end

  def pretty_name
    return "" unless self.fullpath.present?

    short_name = File.basename(self.fullpath, ".md")
    Material.prettify(short_name)
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
    hash = { title: pretty_name }
    hash[:path] = link unless link.blank?
    hash[:children] = child_hash_array unless child_hash_array.empty?
    hash
  end

  protected

  def item
    @item
  end

  private

  def self.insert_into_tree(material, root, skip_files_matching)
    return if material.fullpath.match(skip_files_matching)
    parent = root.find(material.directory)
    parent.incorporate_child(material)
  end
end

class Material
  # FIXME: fullpath should really be fullfilename or fullfilepath!
  attr_accessor :children

  ROOT = "."

  def initialize(item = nil)
    @children = []
    @item = item
  end

  # FIXME: Pick a better name
  def self.ls(client, repository, directory)
    contents = client.contents(repository, path: directory)
    contents.map{ |item| Material.new(item) }
  end

  def self.lookup(filepath, repository, client)
    begin
      result = client.contents(repository, path: filepath)
      Material.new(result)
    rescue Octokit::Forbidden
      directory = File.dirname(filepath)
      sibling_materials = Material.ls(client, repository, directory)
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
    return unless child.is_markdown? or child.directory?
    if self.pretty_name == child.pretty_name
      @shadow = child
    else
      self.children << child
    end
  end

  def content
    Base64.decode64(@item.content) if @item.content.present?
  end

  def descendants
    all_descendants = @children + @children.map(&:descendants)
    all_descendants.flatten.sort_by!{ |m| m.pretty_name }
  end

  def directory?
    @item.type == "tree"
  end

  def edit_url
    @item.html_url.gsub("blob", "edit")
  end

  def extension
    File.extname(self.fullpath)
  end

  # FIXME: This is expensive!
  def find(fullpath)
    all = descendants
    all << self
    all.find{ |c| c.matches?(fullpath) }
  end

  def matches?(fullpath)
    self.fullpath == fullpath || @shadow.try(:matches?, fullpath)
  end

  def filename
    File.basename(self.fullpath)
  end

  def fullpath
    @item.try(:path) || ROOT
  end

  # FIXME: No need for is_
  def is_leaf?
    self.children.empty?
  end

  # FIXME: No need for is_
  def is_markdown?
    extension == ".md"
  end

  def link
    if @shadow.present?
      @shadow.link
    elsif is_markdown?
      "materials/" + self.fullpath
    else
      nil
    end
  end

  # FIXME: This should be renamed "directory"
  def path
    File.dirname(self.fullpath)
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

  # FIXME: This should be in a view helper
  def pretty_path
    path.split("/").map{|s| Material.prettify(s)}.join(" > ")
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
    if @shadow.present?
      hash = @shadow.to_hash
    else
      hash = { title: pretty_name }
      hash[:path] = link unless link.blank?
    end
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
    parent = root.find(material.path)
    unless parent
      puts material.fullpath
    end
    parent.incorporate_child(material)
  end
end

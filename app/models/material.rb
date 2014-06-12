class Material
  attr_accessor :sha, :path, :short_name, :filename, :linkable, :children, :fullpath, :content, :type, :extension

  def initialize(tree_item = nil)
    @children = []
    return unless tree_item.present?

    @fullpath = tree_item.path
    @filename = File.basename(@fullpath)
    @path = File.dirname(@fullpath)
    @short_name = File.basename(@fullpath, ".md")
    @extension = File.extname(tree_item.path)

    @linkable = (@extension == ".md")

    @sha = tree_item.sha

    @type = tree_item.type
    @html_url = tree_item.html_url
    if tree_item.content.present?
      @content = Base64.decode64(tree_item.content)
    end
  end

  def link
    "materials/" + @fullpath if @linkable
  end

  def self.ls(client, source_repository, directory)
    @source_repository = source_repository
    client.contents(source_repository, path: directory).map do |path|
      Material.new(path)
    end
  end

  def self.root(client, source_repository, skip = /^$/)
    @source_repository = source_repository
    tree = client.tree(source_repository, "master", recursive: true).tree
    ancestor_material = Material.new()
    tree.each do |item|
      path = item.path
      populate_path_into(item, path, ancestor_material, skip)
    end
    ancestor_material
  end

  def self.populate_path_into(item, path, ancestor_material, skip)
    return if path.match(skip)
    subdirectory_or_file, remaining_path = path.split("/", 2)
    if remaining_path.blank? # Because we are now in this item's parent directory
      ancestor_material.add_child( item )
    else
      closer_ancestor = ancestor_material.find_child(subdirectory_or_file)
      populate_path_into(item, remaining_path, closer_ancestor, skip)
    end
  end

  def self.lookup(path, source_repository, client)
    begin
      result = client.contents(source_repository, path: path)
      Material.new(result)
    rescue Octokit::Forbidden

      directory = File.dirname(path)
      materials = Material.ls(client, source_repository, directory)
      material = materials.find{|material| material.fullpath == path}
      sha = material.sha
      blob = client.blob(source_repository, sha)
      blob.path = path

      Material.new(blob)
    end
  end

  def edit_url
    @html_url.gsub("blob", "edit")
  end

  def is_leaf?
    @children.empty?
  end

  def is_markdown?
    File.extname(fullpath) == ".md"
  end

  def self.prettify(string)
    string.titleize.
      gsub(/^\d\d\s/, "").
      gsub("To", "to").
      gsub("And", "and").
      gsub("Erb", "ERB").
      gsub("Actionview", "ActionView")
  end

  def pretty_name
    Material.prettify(short_name)
  end

  def pretty_path
    path.split("/").map{|s| Material.prettify(s)}.join(" > ")
  end

  def add_child(tree_item)
    return if tree_item.type == "blob" and File.extname(tree_item.path) != ".md"
    child = Material.new(tree_item)
    if child.short_name == self.short_name
      self.fullpath = child.fullpath
      @linkable = true
    else
      @children << child
    end
  end

  def descendants
    all_descendants = @children + @children.map(&:descendants)
    all_descendants.flatten.sort_by!{ |m| m.pretty_name }
  end

  def find_child(filename)
    @children.find{ |c| c.filename == filename }
  end

  def find_descendant_by_link(link)
    @children.find{ |c| c.link == link } || @children.map{ |c| c.find_descendant_by_link(link) }.compact.first
  end

  def to_hash
    child_hash_array = []
    self.children.each do |child|
      child_hash_array << child.to_hash
    end

    return child_hash_array if path.nil?

    hash = { title: pretty_name }
    hash[:path] = link unless link.blank?
    hash[:children] = child_hash_array unless child_hash_array.empty?
    hash
  end
end

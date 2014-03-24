class Material
  attr_accessor :path, :link, :filename, :children, :fullpath, :content, :type

  def initialize(tree_item = nil)
    @children = []
    return unless tree_item.present?
    @fullpath = tree_item.path
    @filename = File.basename(@fullpath, ".md")
    @path = File.dirname(@fullpath)
    @type = tree_item.type
    if tree_item.type == "blob"
      @link = "materials/" + @fullpath
    end
    if tree_item.type == "file"
      @content = Base64.decode64(tree_item.content)
    end
  end

  def self.source_repository
    Rails.env.test? ? @source_repository : ENV["MATERIALS_REPO"]
  end

  def self.root(client, source_repository)
    @source_repository = source_repository
    tree = client.tree(source_repository, "master", recursive: true).tree
    ancestor_material = Material.new()
    tree.each do |item|
      path = item.path
      populate_path_into(item, path, ancestor_material)
    end
    ancestor_material
  end

  def self.populate_path_into(item, path, ancestor_material)
    return if path.start_with? "exercises"
    subdirectory_or_file, remaining_path = path.split("/", 2)
    if remaining_path.blank? # Because we are now in this item's parent directory
      ancestor_material.add_child( item )
    else
      closer_ancestor = ancestor_material.find_child(subdirectory_or_file)
      populate_path_into(item, remaining_path, closer_ancestor)
    end
  end

  def self.lookup(path, client)
    result = client.contents(source_repository, path: path)
    Material.new(result)
  end

  def pretty_name
    filename.titleize.
      gsub("To", "to").
      gsub("And", "and").
      gsub("Erb", "ERB").
      gsub("Actionview", "ActionView")
  end

  def add_child(tree_item)
    return if tree_item.type == "blob" and File.extname(tree_item.path) != ".md"
    child = Material.new(tree_item)
    if child.filename == self.filename
      self.link = child.link
    else
      @children << child
    end
  end

  def find_child(filename)
    @children.find{ |c| c.filename == filename }
  end
end

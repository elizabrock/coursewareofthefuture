class Material
  attr_accessor :path, :link, :filename, :children, :fullpath

  def initialize(tree_item = nil)
    @children = []
    return unless tree_item.present?
    @fullpath = tree_item.path
    @filename = File.basename(@fullpath, ".md")
    @path = File.dirname(@fullpath)
    if tree_item.type == "blob"
      @link = @fullpath
    end
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

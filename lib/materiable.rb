module Materiable
  def directory
    File.dirname(self.fullpath)
  end

  def extension
    File.extname(self.fullpath)
  end

  def fullpath
    material_fullpath
  end

  def markdown?
    extension == ".md"
  end

  def formatted_title
    return "" unless self.fullpath.present?
    Material.prettify(File.basename(fullpath, ".md"))
  end
end

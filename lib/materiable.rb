module Materiable
  def directory
    File.dirname(self.fullpath)
  end

  def fullpath
    material_fullpath.gsub("materials/", "")
  end

  def formatted_title
    return "" unless self.fullpath.present?
    Material.prettify(File.basename(fullpath, ".md"))
  end
end

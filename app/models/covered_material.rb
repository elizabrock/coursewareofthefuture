class CoveredMaterial < ActiveRecord::Base
  belongs_to :course
  validates_presence_of :covered_on
  validates_presence_of :material_fullpath
  validates :material_fullpath, uniqueness: { scope: :course,
    message: "should be covered once per course" }

  default_scope ->{ order("covered_on ASC, id ASC") }

  def directory
    File.dirname(self.fullpath)
  end

  def fullpath
    material_fullpath.gsub("materials/", "")
  end

  def formatted_title
    Material.prettify(File.basename(fullpath, ".md"))
  end
end

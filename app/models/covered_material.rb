class CoveredMaterial < ActiveRecord::Base
  belongs_to :course
  validates_presence_of :covered_on
  validates :material_fullpath, uniqueness: { scope: :course,
    message: "should be covered once per course" }

  default_scope ->{ order("covered_on ASC, id ASC") }
  after_validation :set_covered_on, on: :create

  def fullpath
    material_fullpath.gsub("materials/","")
  end

  def material(client)
    Material.lookup(fullpath, course.source_repository, client)
  end

  def formatted_title
    Material.prettify(File.basename(fullpath, ".md"))
  end

  private

  def set_covered_on
    self.covered_on ||= Date.today
  end
end

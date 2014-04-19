class CoveredMaterial < ActiveRecord::Base
  belongs_to :course
  validates_presence_of :covered_on

  default_scope ->{ order("covered_on ASC, id ASC") }
  before_validation :set_covered_on, on: :create

  def fullpath
    material_fullpath.gsub("materials/","")
  end

  def material(client)
    Material.lookup(fullpath, course.source_repository, client)
  end

  private

  def set_covered_on
    self.covered_on ||= Date.today
  end
end

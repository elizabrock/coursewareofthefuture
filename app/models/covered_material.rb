require 'materiable'

class CoveredMaterial < ActiveRecord::Base
  include Materiable

  belongs_to :course

  validates_presence_of :covered_on
  validates_presence_of :material_fullpath
  validates :material_fullpath, uniqueness: { scope: :course_id,
    message: "should be covered once per course" }

  default_scope ->{ order("covered_on ASC, id ASC") }
end

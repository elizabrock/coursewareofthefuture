class CoveredMaterial < ActiveRecord::Base
  belongs_to :course

  default_scope ->{ order("covered_on ASC, id ASC") }
end

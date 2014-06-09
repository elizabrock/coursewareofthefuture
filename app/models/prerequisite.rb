class Prerequisite < ActiveRecord::Base
  belongs_to :assignment, inverse_of: :prerequisites

  validates_presence_of :assignment
  validates_presence_of :materials_fullpath
end

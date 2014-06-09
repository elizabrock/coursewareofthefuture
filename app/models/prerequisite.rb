class Prerequisite < ActiveRecord::Base
  belongs_to :assignment, inverse_of: :prerequisites

  validates_presence_of :assignment
end

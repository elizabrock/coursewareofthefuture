require 'materiable'

class Prerequisite < ActiveRecord::Base
  include Materiable

  belongs_to :assignment, inverse_of: :prerequisites

  validates_presence_of :assignment
  validates_presence_of :material_fullpath
end

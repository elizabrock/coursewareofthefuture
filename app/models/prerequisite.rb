require 'materiable'

class Prerequisite < ActiveRecord::Base
  include Materiable

  belongs_to :assignment

  validates_presence_of :assignment
  validates_presence_of :material_fullpath
end

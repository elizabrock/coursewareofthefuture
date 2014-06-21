require 'materiable'

class ReadMaterial < ActiveRecord::Base
  include Materiable

  belongs_to :user

  validates_presence_of :material_fullpath
  validates_presence_of :user
end

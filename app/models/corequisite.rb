require 'materiable'

class Corequisite
  include Materiable

  attr_reader :material_fullpath

  def initialize(material_fullpath)
    @material_fullpath = material_fullpath
  end
end

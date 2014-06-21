class ReadMaterial < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :material_fullpath
  validates_presence_of :user

  def pretty_name
    short_name = File.basename(material_fullpath, ".md")
    Material.prettify(short_name)
  end
end

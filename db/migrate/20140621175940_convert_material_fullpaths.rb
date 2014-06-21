class MyCoveredMaterial < ActiveRecord::Base
  self.table_name = :covered_materials
end
class MyPrerequisites < ActiveRecord::Base
  self.table_name = :prerequisites
end
class MyReadMaterial < ActiveRecord::Base
  self.table_name = :read_materials
end

class ConvertMaterialFullpaths < ActiveRecord::Migration
  def up
    materialishes = (MyCoveredMaterial.all + MyPrerequisites.all + MyReadMaterial.all).flatten
    materialishes.each do |materialish|
      materialish.material_fullpath.gsub!("materials/","")
      materialish.save!
    end
  end
end

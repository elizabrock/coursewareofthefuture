class ConvertMaterialFullpaths < ActiveRecord::Migration
  class MyCoveredMaterial < ActiveRecord::Base
    self.table_name = "covered_materials"
  end
  class MyPrerequisites < ActiveRecord::Base
    self.table_name = "prerequisites"
  end
  class MyReadMaterial < ActiveRecord::Base
    self.table_name = "read_materials"
  end
  def up
    materialishes = (MyCoveredMaterial.all + MyPrerequisites.all + MyReadMaterial.all).flatten
    materialishes.each do |m|
      if m.material_fullpath.present?
        m.material_fullpath = m.material_fullpath.gsub("materials/","")
        m.save!
      end
    end
  end
end

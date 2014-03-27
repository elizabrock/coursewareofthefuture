class CreateCoveredMaterials < ActiveRecord::Migration
  def change
    create_table :covered_materials do |t|
      t.integer :course_id
      t.string :material_fullpath

      t.timestamps
    end
  end
end

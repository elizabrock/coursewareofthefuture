class CreateReadMaterials < ActiveRecord::Migration
  def change
    create_table :read_materials do |t|
      t.integer :user_id
      t.string :material_fullpath

      t.timestamps
    end
  end
end

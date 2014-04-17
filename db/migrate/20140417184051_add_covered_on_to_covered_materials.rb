class AddCoveredOnToCoveredMaterials < ActiveRecord::Migration
  def change
    add_column :covered_materials, :covered_on, :date
  end
end

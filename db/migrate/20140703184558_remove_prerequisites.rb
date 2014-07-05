class RemovePrerequisites < ActiveRecord::Migration
  def up
    drop_table :prerequisites
  end

  def down
    create_table :prerequisites do |t|
      t.string :material_fullpath
      t.integer :assignment_id

      t.timestamps
    end
  end
end

class DropTableInstructors < ActiveRecord::Migration
  def up
    drop_table :instructors
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

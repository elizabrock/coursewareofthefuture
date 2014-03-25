class RenameStudentsToUsers < ActiveRecord::Migration
  def up
    rename_table :students, :users
    add_column :users, :instructor, :boolean
  end

  def down
    remove_column :users, :instructor
    rename_table :users, :students
  end
end

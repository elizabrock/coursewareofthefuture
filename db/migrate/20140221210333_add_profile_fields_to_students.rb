class AddProfileFieldsToStudents < ActiveRecord::Migration
  def change
    add_column :students, :name, :string
    add_column :students, :phone, :string
  end
end

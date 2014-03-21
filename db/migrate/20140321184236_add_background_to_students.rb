class AddBackgroundToStudents < ActiveRecord::Migration
  def change
    add_column :students, :background, :text
  end
end



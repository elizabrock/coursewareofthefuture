class AddGoalsToStudents < ActiveRecord::Migration
  def change
    add_column :students, :goals, :text
  end
end

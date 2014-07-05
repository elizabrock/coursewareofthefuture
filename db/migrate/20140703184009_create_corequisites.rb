class CreateCorequisites < ActiveRecord::Migration
  def change
    add_column :milestones, :corequisite_fullpaths, :text, array: true
    add_column :quizzes, :corequisite_fullpaths, :text, array: true
  end
end

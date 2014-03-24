class RemoveActiveCourseFromCourses < ActiveRecord::Migration
  def change
    remove_column :courses, :active_course, :boolean
  end
end

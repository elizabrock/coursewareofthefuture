class RemoveSyllabusFromCourses < ActiveRecord::Migration
  def change
    remove_column :courses, :syllabus, :text
  end
end

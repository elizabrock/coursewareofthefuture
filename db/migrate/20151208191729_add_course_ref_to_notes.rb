class AddCourseRefToNotes < ActiveRecord::Migration
  def change
    add_reference :notes, :course, index: true, foreign_key: true
  end
end

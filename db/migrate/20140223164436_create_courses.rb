class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :title
      t.text :syllabus
      t.date :start_date
      t.date :end_date
      t.boolean :active_course

      t.timestamps
    end
  end
end

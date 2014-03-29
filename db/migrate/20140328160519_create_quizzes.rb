class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.integer :course_id
      t.string :title
      t.datetime :deadline

      t.timestamps
    end
  end
end

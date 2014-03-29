class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :quiz_id
      t.text :question
      t.string :question_type
      t.text :correct_answer

      t.timestamps
    end
  end
end

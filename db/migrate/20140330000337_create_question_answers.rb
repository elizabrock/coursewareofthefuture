class CreateQuestionAnswers < ActiveRecord::Migration
  def change
    create_table :question_answers do |t|
      t.integer :quiz_submission_id
      t.integer :question_id
      t.text :answer
      t.integer :score

      t.timestamps
    end
  end
end

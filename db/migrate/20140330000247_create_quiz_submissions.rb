class CreateQuizSubmissions < ActiveRecord::Migration
  def change
    create_table :quiz_submissions do |t|
      t.integer :user_id
      t.integer :quiz_id
      t.datetime :submitted_at

      t.timestamps
    end
  end
end

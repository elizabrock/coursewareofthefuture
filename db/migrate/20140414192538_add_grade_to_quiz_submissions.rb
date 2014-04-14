class AddGradeToQuizSubmissions < ActiveRecord::Migration
  def change
    add_column :quiz_submissions, :grade, :integer
  end
end

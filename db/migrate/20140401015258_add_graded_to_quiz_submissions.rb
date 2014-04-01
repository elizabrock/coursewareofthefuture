class AddGradedToQuizSubmissions < ActiveRecord::Migration
  def change
    add_column :quiz_submissions, :graded, :boolean
  end
end

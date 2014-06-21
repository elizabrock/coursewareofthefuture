class ChangeDeadlineToDate < ActiveRecord::Migration
  def up
    change_column :events, :date, :date
    change_column :milestones, :deadline, :date
    change_column :quizzes, :deadline, :date
  end

  def down
    change_column :events, :date, :datetime
    change_column :milestones, :deadline, :datetime
    change_column :quizzes, :deadline, :datetime
  end
end

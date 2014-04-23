class CreateMilestoneSubmissions < ActiveRecord::Migration
  def change
    create_table :milestone_submissions do |t|
      t.integer :user_id
      t.integer :milestone_id
      t.string :repository
      t.string :status

      t.timestamps
    end
  end
end

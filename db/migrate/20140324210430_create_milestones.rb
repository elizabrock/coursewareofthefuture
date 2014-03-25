class CreateMilestones < ActiveRecord::Migration
  def change
    create_table :milestones do |t|
      t.integer :assignment_id
      t.string :title
      t.text :instructions
      t.datetime :deadline

      t.timestamps
    end
  end
end

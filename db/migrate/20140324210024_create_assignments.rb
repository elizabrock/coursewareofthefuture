class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :course_id
      t.string :title
      t.text :summary
      t.boolean :published

      t.timestamps
    end
  end
end

class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :course_id
      t.datetime :date
      t.string :summary

      t.timestamps
    end
  end
end

class DropTableSelfReports < ActiveRecord::Migration
  def up
    drop_table :table_self_reports
  end

  def down
    create_table :table_self_reports do |t|
      t.boolean :attended
      t.float :hours_coding
      t.float :hours_learning
      t.float :hours_slept
      t.datetime :date
    end
  end
end

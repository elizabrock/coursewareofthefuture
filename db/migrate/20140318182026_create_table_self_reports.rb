class CreateTableSelfReports < ActiveRecord::Migration
  def change
    create_table :table_self_reports do |t|
      t.boolean :attended
      t.float :hours_coding
      t.float :hours_learning
      t.float :hours_slept
      t.datetime :date
    end
  end
end

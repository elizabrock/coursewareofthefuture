class AddColumnsToSelfReports < ActiveRecord::Migration
  def change
    add_column :self_reports, :student_id, :integer
    add_column :self_reports, :attended, :boolean
    add_column :self_reports, :hours_coding, :float
    add_column :self_reports, :hours_learning, :float
    add_column :self_reports, :hours_slept, :float
    add_column :self_reports, :date, :datetime
  end
end

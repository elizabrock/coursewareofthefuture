class RenameStudentIdToUserIdOnSelfReports < ActiveRecord::Migration
  def change
    rename_column :self_reports, :student_id, :user_id
  end
end

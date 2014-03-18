class RemovePasswordAuthColumnsFromStudents < ActiveRecord::Migration
  def change
    remove_column :students, :encrypted_password, :string
    remove_column :students, :reset_password_token, :string
    remove_column :students, :reset_password_sent_at, :datetime
    remove_column :students, :confirmation_token, :string
    remove_column :students, :confirmed_at, :datetime
    remove_column :students, :confirmation_sent_at, :datetime
  end
end

class AddOmniauthColumnsToStudents < ActiveRecord::Migration
  def change
    add_column :students, :github_uid, :string
    add_column :students, :github_username, :string
    add_column :students, :avatar_url, :string
  end
end

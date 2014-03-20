class AddGithubAccessTokenToStudents < ActiveRecord::Migration
  def change
    add_column :students, :github_access_token, :string
  end
end

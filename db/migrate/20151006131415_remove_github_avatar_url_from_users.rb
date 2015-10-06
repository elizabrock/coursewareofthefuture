class RemoveGithubAvatarUrlFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :github_avatar_url, :string
  end
end

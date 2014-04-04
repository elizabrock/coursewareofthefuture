class RenameAvatarToPhotoOnUsers < ActiveRecord::Migration
  def change
    rename_column :users, :avatar_confirmed, :photo_confirmed
    remove_column :users, :avatar_url, :string
  end
end

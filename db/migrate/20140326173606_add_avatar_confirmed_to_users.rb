class AddAvatarConfirmedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar_confirmed, :boolean, default: false
  end
end

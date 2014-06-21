class AddObserverToUsers < ActiveRecord::Migration
  def change
    add_column :users, :observer, :boolean
  end
end

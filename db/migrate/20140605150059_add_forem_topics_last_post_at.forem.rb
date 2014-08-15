# This migration comes from forem (originally 20120222000227)
class AddForemTopicsLastPostAt < ActiveRecord::Migration
  def up
    add_column :forem_topics, :last_post_at, :datetime
  end

  def down
    remove_column :forem_topics, :last_post_at
  end
end

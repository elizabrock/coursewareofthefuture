# This migration comes from forem (originally 20120302152918)
class AddForemViewFields < ActiveRecord::Migration
  def up
    add_column :forem_views, :current_viewed_at, :datetime
    add_column :forem_views, :past_viewed_at, :datetime
    add_column :forem_topics, :views_count, :integer, :default=>0
    add_column :forem_forums, :views_count, :integer, :default=>0
  end

  def down
    remove_column :forem_views, :current_viewed_at
    remove_column :forem_views, :past_viewed_at
    remove_column :forem_topics, :views_count
    remove_column :forem_forums, :views_count
  end
end

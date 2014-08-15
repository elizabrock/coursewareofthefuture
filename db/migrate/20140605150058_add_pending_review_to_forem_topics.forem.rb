# This migration comes from forem (originally 20120221195807)
class AddPendingReviewToForemTopics < ActiveRecord::Migration
  def change
    add_column :forem_topics, :pending_review, :boolean, :default => true
  end
end

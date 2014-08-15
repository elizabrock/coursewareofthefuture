# This migration comes from forem (originally 20111103214432)
class AddCategoryIdToForums < ActiveRecord::Migration
  def change
    add_column :forem_forums, :category_id, :integer
  end
end

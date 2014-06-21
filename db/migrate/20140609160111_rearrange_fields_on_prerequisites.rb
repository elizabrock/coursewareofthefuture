class RearrangeFieldsOnPrerequisites < ActiveRecord::Migration
  def up
    add_column :prerequisites, :material_fullpath, :string
    remove_column :prerequisites, :url
    remove_column :prerequisites, :note
  end

  def down
    remove_column :prerequisites, :material_fullpath
    add_column :prerequisites, :url, :string
    add_column :prerequisites, :note, :text
  end
end

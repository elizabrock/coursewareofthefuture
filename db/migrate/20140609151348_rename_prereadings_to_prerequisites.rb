class RenamePrereadingsToPrerequisites < ActiveRecord::Migration
  def change
    rename_table :prereadings, :prerequisites
  end
end

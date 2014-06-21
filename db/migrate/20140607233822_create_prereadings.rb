class CreatePrereadings < ActiveRecord::Migration
  def change
    create_table :prereadings do |t|
      t.string :url
      t.integer :assignment_id
      t.text :note

      t.timestamps
    end
  end
end

class CreateSelfReports < ActiveRecord::Migration
  def change
    create_table :self_reports do |t|

      t.timestamps
    end
  end
end

class AddNameToScheduledReport < ActiveRecord::Migration[5.2]
  def change
    add_column :scheduled_reports, :name, :string, null: false
    add_index :scheduled_reports, :name, unique: true
  end
end

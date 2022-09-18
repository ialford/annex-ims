class AddNicknameToScheduledReport < ActiveRecord::Migration[5.2]
  def change
    add_column :scheduled_reports, :nickname, :string, null: false
    add_index :scheduled_reports, :nickname, unique: true
  end
end

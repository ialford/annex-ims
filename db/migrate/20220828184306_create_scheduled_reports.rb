class CreateScheduledReports < ActiveRecord::Migration[5.2]
  def change
    create_table :scheduled_reports do |t|
      t.string :canned_report_id, index: true, null: false
      t.string :email, null: false
      t.jsonb :params, null: false
      t.timestamp :last_run_at
      t.string :cancel, null: false
      t.jsonb :schedule, null: false

      t.timestamps
    end
    add_index :scheduled_reports, :cancel, unique: true
  end
end

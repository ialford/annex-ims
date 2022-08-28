json.extract! scheduled_report, :id, :canned_report_id, :email, :params, :last_run_at, :cancel, :schedule, :created_at, :updated_at
json.url scheduled_report_url(scheduled_report, format: :json)

# frozen_string_literal: true

class BuildCannedReport
  def self.call(fields, start_date, end_date, preset_date_range, activity, request_status, item_status)
    new(fields, start_date, end_date, preset_date_range, activity, request_status, item_status).build!
    end

  def initialize(fields, start_date, end_date, preset_date_range, activity, request_status, item_status); end

  def build!
    sql = to_sql
    results = ActiveRecord::Base.connection.execute(sql).to_a

    {
      results: results,
      sql: sql
    }
  end

  def to_sql; end
end

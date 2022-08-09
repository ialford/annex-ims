# frozen_string_literal: true

class BuildCannedReport
  def self.call(params)
    new(params).build!
  end

  def initialize(params); end

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

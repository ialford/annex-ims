# frozen_string_literal: true

class BuildReport
  attr_reader :fields,
              :start_date,
              :end_date,
              :activity,
              :status,
              :selects,
              :joins,
              :from,
              :where_conditions,
              :where_values,
              :orders

  def self.call(fields, start_date, end_date, activity, status)
    new(fields, start_date, end_date, activity, status).build!
  end

  def initialize(fields, start_date, end_date, activity, status)
    @fields = fields
    @start_date = start_date
    @end_date = end_date
    @activity = activity
    @status = status

    @selects = ['a.created_at AS "activity"']
    @joins = []
    @from = 'activity_logs a'
    @where_conditions = ['a.action = :activity']
    @where_values = { activity: @activity }
    @wheres = []
    @orders = ['a.created_at']
  end

  def build!
    sql = to_sql
    results = ActiveRecord::Base.connection.execute(to_sql).to_a

    {
      results: results,
      sql: sql
    }
  end

  def to_sql
    fields.each do |field|
      send("handle_#{field}".to_sym)
    end

    handle_start_date if @start_date.present?
    handle_end_date if @end_date.present?
    handle_status if @status.present?

    @wheres = [@where_conditions.uniq.join(' and '), @where_values]

    sql = ActivityLog.select(@selects.uniq).from(@from).joins(@joins.uniq).where(@wheres).order(@orders.uniq).to_sql

    sql
  end

  private

  def handle_requested
    @selects.append('b.created_at AS "requested"')

    @joins.append("LEFT JOIN activity_logs b ON CAST(a.data->'request'->>'id' AS INTEGER) = CAST(b.data->'request'->>'id' AS INTEGER) AND b.action = 'ReceivedRequest'")
    @joins.append("LEFT JOIN activity_logs p ON CAST(a.data->'item'->>'id' AS INTEGER) = CAST(p.data->'item'->>'id' AS INTEGER) AND p.action = 'AssociatedItemAndBin' AND p.created_at BETWEEN b.created_at AND a.created_at")

    @orders.append('b.created_at')
  end

  def handle_pulled
    @selects.append('p.created_at AS "pulled"')

    @joins.append("LEFT JOIN activity_logs b ON CAST(a.data->'request'->>'id' AS INTEGER) = CAST(b.data->'request'->>'id' AS INTEGER) AND b.action = 'ReceivedRequest'")
    @joins.append("LEFT JOIN activity_logs p ON CAST(a.data->'item'->>'id' AS INTEGER) = CAST(p.data->'item'->>'id' AS INTEGER) AND p.action = 'AssociatedItemAndBin' AND p.created_at BETWEEN b.created_at AND a.created_at")

    @orders.append('p.created_at')
  end

  def handle_filled
    @selects.append('f.created_at AS "filled"')

    @joins.append("LEFT JOIN activity_logs f ON CAST(a.data->'request'->>'id' AS INTEGER) = CAST(f.data->'request'->>'id' AS INTEGER) AND f.action = 'FilledRequest'")

    @orders.append('f.created_at')
  end

  def handle_source
    @selects.append("a.data->'request'->'source' AS \"source\"")
  end

  def handle_request_type
    @selects.append("a.data->'request'->'req_type' AS \"request_type\"")
  end

  def handle_patron_status
    @selects.append("a.data->'request'->'patron_status' AS \"patron_status\"")
  end

  def handle_institution
    @selects.append("a.data->'request'->'patron_institution' AS \"institution\"")
  end

  def handle_department
    @selects.append("a.data->'request'->'patron_department' AS \"department\"")
  end

  def handle_pickup_location
    @selects.append("a.data->'request'->'pickup_location' AS \"pickup_location\"")
  end

  def handle_class
    @selects.append('TRIM(SUBSTR(i.call_number,1,2)) AS "class"')

    @joins.append("LEFT JOIN items i ON CAST(a.data->'item'->>'id' AS INTEGER) = i.id")
  end

  def handle_time_to_pull; end

  def handle_time_to_fill; end

  def handle_start_date
    @where_conditions.append('a.created_at >= :start_date')

    @where_values[:start_date] = @start_date
  end

  def handle_end_date
    @where_conditions.append('a.created_at <= :end_date')

    @where_values[:end_date] = @end_date
  end

  def handle_status; end
end

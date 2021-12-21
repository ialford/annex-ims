# frozen_string_literal: true

class CannedReport
  attr_reader :id, :name, :file
  attr_accessor :contents

  def initialize(id)
    @id = id
    @name = id.titleize
    @file = File.join(Rails.root, 'reports', "#{id}.yaml")
  end

  def valid?
    File.exist?(@file)
  end

  def load
    @contents = YAML.safe_load(File.read(@file))
  end

  def run(params)
    errors = validate(params)
    return { errors: errors, results: [], sql: '' } if errors.any?

    sql, errors = to_sql(params)
    sql, errors = nil, []

    return { errors: errors, results: [], sql: sql } if errors.any?

    results = ActiveRecord::Base.connection.execute(sql).to_a
    { errors: errors, results: results, sql: sql }
  end

  def to_sql(params)
    base_sql = @contents['base_sql']
    errors = []

    use_date_range = false
    start_date = nil
    end_date = nil

    @contents['parameters'].each do |param|
      case param['type']
      when 'checkbox'
        if params.key?(param['name']) && params[param['name']] == '1'
          param['sql'].each do |sql|
            base_sql = base_sql.gsub(/#{sql['key']}/, sql['value'])
          end
        end
      when 'date'

      when 'multi-select'

      when 'preset-date-range'
        case params[param['name']]
        when 'current_day'
          start_date = Time.zone.today.beginning_of_day
          end_date = Time.zone.today.end_of_day
        when 'previous_day'
          start_date = Time.zone.yesterday.beginning_of_day
          end_date = Time.zone.yesterday.end_of_day
        when 'current_week'
          start_date = Time.zone.today.beginning_of_week(start_day = :monday).beginning_of_day
          end_date = Time.zone.today.end_of_day
        when 'previous_week'
          start_date = Time.zone.today.beginning_of_week(start_day = :monday).last_week.beginning_of_day
          end_date = (Time.zone.today.beginning_of_week(start_day = :monday).last_week + 6).end_of_day
        when 'current_month'
          start_date = Time.zone.today.beginning_of_month.beginning_of_day
          end_date = Time.zone.today.end_of_day
        when 'previous_month'
          start_date = 1.month.ago.beginning_of_month.beginning_of_day
          end_date = 1.month.ago.end_of_month.end_of_day
        when 'current_year'
          start_date = Time.zone.today.beginning_of_year.beginning_of_day
          end_date = Time.zone.today.end_of_day
        when 'current_fiscal_year'
          start = Time.zone.today
          start = start.change(year: start.year - 1) if start.month < 7
          start = start.change(month: 7).beginning_of_month
          start_date = start.beginning_of_day
          end_date = Time.zone.today.end_of_day
        else
          use_date_range = true
        end
      when 'radio'

      when 'text'

      end
    end

    if base_sql

    end

    return base_sql, errors
  end

  def validate(params)
    errors = []
      @contents['parameters'].each do |param|
        if param['required'] && !params.key?(param['name'])
          errors << "Missing required parameter: #{param['name']}"
        end

        case param['type']
        when 'checkbox'
          if params.key?(param['name']) && !['0', '1'].include?(param['name'])
            errors << "Invalid value for checkbox: #{param['name']} - #{params[param['name']]}"
          end
        when 'date'
          if params.key?(param['name']) && params[param['name']] != '' && !(Date.strptime(params[param['name']], "%Y-%m-%d") rescue false)
            errors << "Invalid date: #{param['name']} - #{params[param['name']]}"
          end
        when 'multi-select'
          if params.key?(param['name']) && !params[param['name']].is_a?(Array) && !(params[param['name']] - param['values']).empty?
            errors << "Invalid value for multi-select: #{param['name']} - #{params[param['name']]}"
          end
        when 'preset-date-range'
          if params.key?(param['name']) && params[param['name']] != '' && !Report::PRESET_DATE_RANGES.keys.include?(params[param['name']])
            errors << "Invalid preset date range: #{param['name']} - #{params[param['name']]}"
          end
        when 'radio'
          if params.key?(param['name']) && !param['values'].keys.include?(params[param['name']])
            errors << "Invalid value for radio: #{param['name']} - #{params[param['name']]}"
          end
        end
      end

    errors
  end

  def save
    File.open(@file, 'w') do |file|
      file.write @contents.to_yaml
    end
  end

  def self.all
    Dir.glob(File.join(Rails.root, 'reports', '*.yaml')).sort.map { |file| CannedReport.new(File.basename(file, File.extname(file))) }
  end
end

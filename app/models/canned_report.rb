# frozen_string_literal: true

class CannedReport
  attr_reader :id, :name, :file
  attr_accessor :contents

  UNSAFE_SQL = %w[
    INSERT
    UPDATE
    DELETE
    CREATE
    ALTER
    DROP
    TRUNCATE
    GRANT
    REVOKE
    LOCK
    UNLOCK
    REPAIR
    OPTIMIZE
    ANALYZE
    BACKUP
    RESTORE
    EXPLAIN
    SHOW
    DESCRIBE
    DESC
  ].freeze

  def initialize(id)
    @id = id
    @name = id.nil? ? '' : id.titleize
    path = if Rails.env.test?
              Rails.root.join('spec', 'fixtures', 'files', 'canned_reports')
            else
              Rails.root.join('reports')
            end
    @file = File.join(path, "#{id}.yaml")
    if valid?
      load
    else
      @contents = {}
    end
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

    return { errors: errors, results: [], sql: sql } if errors.any?

    errors = CannedReport.validate_sql(sql)

    return { errors: errors, results: [], sql: sql } if errors.any?

    results = ActiveRecord::Base.connection.execute(sql).to_a
    { errors: errors, results: results, sql: sql }
  end

  def to_sql(params)
    base_sql = @contents['base_sql']
    errors = []

    start_date = nil
    end_date = nil

    @contents['parameters'].each do |param|
      case param['type']
      when 'checkbox'
        param['value'][params[param['name']]]['sql'].each do |sql|
          base_sql = base_sql.gsub(/#{sql['key']}/, sql['value'])
        end
      when 'date'
        # TODO: implement
      when 'number'
        param['sql'].each do |sql|
          if params.key?(param['name']) && !params[param['name']].empty?
            tmp = sql['value'].gsub('VALUE', params[param['name']])
            base_sql = base_sql.gsub(/#{sql['key']}/, tmp)
          else
            base_sql = base_sql.gsub(/#{sql['key']}/, '')
          end
        end
      when 'multi-select'
        param['sql'].each do |sql|
          if params.key?(param['name']) && !params[param['name']].empty?
            tmp = sql['value'].gsub('PARAMS', "'" + params[param['name']].join("', '") + "'")
            base_sql = base_sql.gsub(/#{sql['key']}/, tmp)
          else
            base_sql = base_sql.gsub(/#{sql['key']}/, '')
          end
        end
      when 'preset-date-range'
        case params[param['name']]
        when 'current_day'
          start_date = Time.zone.today.beginning_of_day
          end_date = Time.zone.today.end_of_day
        when 'previous_day'
          start_date = Time.zone.yesterday.beginning_of_day
          end_date = Time.zone.yesterday.end_of_day
        when 'current_week'
          start_date = Time.zone.today.beginning_of_week(:monday).beginning_of_day
          end_date = Time.zone.today.end_of_day
        when 'previous_week'
          start_date = Time.zone.today.beginning_of_week(:monday).last_week.beginning_of_day
          end_date = (Time.zone.today.beginning_of_week(:monday).last_week + 6).end_of_day
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
        end
        param['sql'].each do |sql|
          tmp = sql['value'].gsub('START_DATE', start_date.strftime('%Y-%m-%d %H:%M:%S'))
          tmp = tmp.gsub('END_DATE', end_date.strftime('%Y-%m-%d %H:%M:%S'))
          base_sql = base_sql.gsub(/#{sql['key']}/, tmp)
        end
      when 'radio'
        if params.key?(param['name']) && !params[param['name']].empty?
          param['values'][params[param['name']]]['sql'].each do |sql|
            base_sql = base_sql.gsub(/#{sql['key']}/, sql['value'])
          end
        end
      when 'text'
        # TODO: implement
      end
    end

    [base_sql.squeeze(' ').strip, errors]
  end

  def validate(params)
    errors = []
    @contents['parameters'].each do |param|
      if param['required'] && !params.key?(param['name'])
        errors << "Missing required parameter: #{param['name']}"
      end

      case param['type']
      when 'checkbox'
        if params.key?(param['name']) && !%w[0 1].include?(params[param['name']])
          errors << "Invalid value for checkbox: #{param['name']} - #{params[param['name']]}"
        end
      when 'date'
        if params.key?(param['name']) && params[param['name']] != '' && !(begin
                                                                            Date.strptime(params[param['name']], '%Y-%m-%d')
                                                                          rescue StandardError
                                                                            false
                                                                          end)
          errors << "Invalid date: #{param['name']} - #{params[param['name']]}"
        end
      when 'number'
        if params.key?(param['name']) && params[param['name']] != ''
          fail = if param['step'].to_i == param['step']
                   !(params[param['name']].to_i % param['step']).zero?
                 else
                   !(params[param['name']].to_f % param['step']).zero?
                 end

          fail ||= if param['min']
                     if param['min'].to_i == param['min']
                       params[param['name']].to_i < param['min']
                     else
                       params[param['name']].to_f < param['min']
                     end
                   end

          fail ||= if param['max']
                     if param['max'].to_i == param['max']
                       params[param['name']].to_i > param['max']
                     else
                       params[param['name']].to_f > param['max']
                     end
                   end

          if fail
            errors << "Invalid number: #{param['name']} - #{params[param['name']]}"
          end
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

  def save!
    save
  end

  def self.all
    Dir.glob(Rails.root.join('reports', '*.yaml')).sort.map { |file| CannedReport.new(File.basename(file, File.extname(file))) }
  end

  def self.find(name)
    CannedReport.new(name)
  end

  def self.validate_sql(sql)
    errors = []
    UNSAFE_SQL.each do |bad|
      if sql.downcase.match(/\b+#{bad.downcase}\b+/)
        errors << "Invalid SQL: #{sql} contains #{bad}"
      end
    end

    errors
  end
end

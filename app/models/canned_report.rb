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

    sql = to_sql(params)
    sql = nil

    results = ActiveRecord::Base.connection.execute(sql).to_a
    { errors: errors, results: results, sql: sql }
  end

  def to_sql(params)
    base_sql = @contents['base_sql']

    @contents['parameters'].each do |param|

    end

    base_sql
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
            errors << "Invalid value for checkbox: #{param['name']}"
          end
        when 'date'
          # if params.key?(param['name']) && !(Date.strptime(param['name'], "%Y-%m-%d") rescue false)
          #   errors << "Invalid date: #{param['name']}"
          # end
        when 'multi-select'

        when 'preset-date-range'
          if params.key?(param['name']) && !Report::PRESET_DATE_RANGES.keys.include?(param['name'])

          end
        when 'radio'
          if params.key?(param['name']) && !param['values'].keys.include?(param['name'])
            errors << "Invalid value for radio: #{param['name']}"
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

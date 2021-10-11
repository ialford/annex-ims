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

  def run
    # BuildCannedReport.call(fields, start_date, end_date, preset_date_range, activity, request_status, item_status) # ????
  end

  def save
    File.open(@file,"w") do |file|
      file.write @contents.to_yaml
    end
  end

  def self.all
    Dir.glob(File.join(Rails.root, 'reports', '*.yaml')).sort.map { |file| CannedReport.new(File.basename(file, File.extname(file))) }
  end
end

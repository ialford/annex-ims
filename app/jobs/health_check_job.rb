class HealthCheckJob < ApplicationJob
  queue_as HealthCheckWorker::QUEUE_NAME

  def perform(date_time)
    if File.exist?(Rails.root.join('tmp', 'sneakers-health-check.json'))
      File.delete(Rails.root.join('tmp', 'sneakers-health-check.json'))
    end
    f = File.new(Rails.root.join('tmp', 'sneakers-health-check.json'), "w+")
    f.puts(date_time)
    f.close
    true
  end

end
class HealthCheckJob < ApplicationJob
  queue_as HealthCheckWorker::QUEUE_NAME

  def perform()
		1
  end
end
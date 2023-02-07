class HealthCheckWorker < RetryWorker
  WORKERS = 1
  QUEUE_NAME = "health-check".freeze

  from_queue QUEUE_NAME,
             threads: 1,
             timeout_job_after: 60,
             prefetch: 1
end
namespace :health do
  desc 'Container Health Check'
	task :check => :environment do
		dt_json = JSON.generate(time: DateTime.now)
		HealthCheckJob.perform_later(dt_json)
		sleep(2.seconds)
		if File.exist?(Rails.root.join('tmp', 'sneakers-health-check.json'))
			f = File.new(Rails.root.join('tmp', 'sneakers-health-check.json'), 'r')
			date_time_json = f.read(dt_json.length)
			if date_time_json.to_s == dt_json
				exit 0
			else
				exit 1
			end
		else
			exit 1
		end
	end
end

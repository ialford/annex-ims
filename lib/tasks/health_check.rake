namespace :health do
	desc "Container Health Check"
	task :check => :environment do
		HealthCheckJob.perform_later
	end
end
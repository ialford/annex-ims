namespace :sample do
  desc "Add some sample admin users to the database"
  task :users => :environment do
		puts 'Create rfox2'
		u = User.where(username: 'rfox2').first
		if (u.nil?)
			u = User.new
			u.username = 'rfox2'
			u.admin = true
			u.worker = false
			u.save!
		end
    puts 'Create wsill'
		u = User.where(username: 'wsill').first
		if (u.nil?)
			u = User.new
			u.username = 'wsill'
			u.admin = true
			u.worker = false
			u.save!
		end
  end
end
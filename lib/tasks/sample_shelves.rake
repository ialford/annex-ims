namespace :sample do
  desc "Add some shelves to the database"
  task :shelves => :environment do
		puts 'Create SHELF-1'
		s = Shelf.where(barcode: 'SHELF-1').first
		if (s.nil?)
			s = Shelf.new
			s.barcode = "SHELF-1"
			s.size = 20
			s.save!
		end
		puts 'Create SHELF-2'
		s = Shelf.where(barcode: 'SHELF-2').first
		if (s.nil?)
			s = Shelf.new
			s.barcode = "SHELF-2"
			s.size = 25
			s.save!
		end
	end
end

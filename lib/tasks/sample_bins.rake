namespace :sample do
  desc "Add some bins to the database"
  task :bins => :environment do
		puts 'Create BIN-ALEPH-LOAN-1'
		b = Bin.where(barcode: 'BIN-ALEPH-LOAN-1').first
		if (b.nil?)
			b = Bin.new
			b.barcode = 'BIN-ALEPH-LOAN-1'
			b.save!
		end
		puts 'Create BIN-ILL-LOAN-1'
		b = Bin.where(barcode: 'BIN-ILL-LOAN-1').first
		if (b.nil?)
			b = Bin.new
			b.barcode = 'BIN-ILL-LOAN-1'
			b.save!
		end
	end
end

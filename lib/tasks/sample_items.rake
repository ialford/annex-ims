namespace :sample do
  desc 'Add items to the database'
  task :items => :environment do
		puts 'Create Disposition GREAT'
		d = Disposition.where(code: 'GREAT').first
		if (d.nil?)
			d = Disposition.new
			d.code = 'GREAT'
			d.description = 'Great'
			d.save!
		end
		puts 'Create Disposition WRECKED'
		d = Disposition.where(code: 'WRECKED').first
		if (d.nil?)
			d = Disposition.new
			d.code = 'WRECKED'
			d.description = 'Not great Bob'
			d.save!
		end
		puts 'Create 9876543210987654'
		i = Item.where(barcode: '9876543210987654').first
		if (i.nil?)
			i = Item.new
			i.barcode = '9876543210987654'
			i.title = 'Huckleberry Finn'
			i.author = 'Mark Twain'
			i.thickness = 2
			i.tray_id = Tray.where(barcode: 'TRAY-TYPE_ONE-1').first.id
			i.created_at = DateTime.now
			i.updated_at = DateTime.now
			i.bib_number = '000669532'
			i.isbn_issn = '0048000779'
			i.initial_ingest = DateTime.now
			i.disposition_id = Disposition.where(code: 'WRECKED').first.id
			i.save!
		end
		puts 'Create 63425194857103'
		i = Item.where(barcode: '63425194857103').first
		if (i.nil?)
			i = Item.new
			i.barcode = '63425194857103'
			i.title = 'The Thing'
			i.author = 'Brandon Thing'
			i.thickness = 3
			i.tray_id = Tray.where(barcode: 'TRAY-TYPE_ONE-1').first.id
			i.created_at = DateTime.now
			i.updated_at = DateTime.now
			i.bib_number = '002074116'
			i.isbn_issn = '0393020398'
			i.initial_ingest = DateTime.now
			i.disposition_id = Disposition.where(code: 'GREAT').first.id
			i.save!
		end
		puts 'Create 540172345976254'
		i = Item.where(barcode: '540172345976254').first
		if (i.nil?)
			i = Item.new
			i.barcode = '540172345976254'
			i.title = 'Life is Wonderful'
			i.author = 'Mark Twain'
			i.thickness = 2
			i.tray_id = Tray.where(barcode: 'TRAY-TYPE_ONE-2').first.id
			i.created_at = DateTime.now
			i.updated_at = DateTime.now
			i.bib_number = '000191132'
			i.isbn_issn = '0048000779'
			i.initial_ingest = DateTime.now
			i.disposition_id = Disposition.where(code: 'WRECKED').first.id
			i.save!
		end
		puts 'Create 9814302375421836'
		i = Item.where(barcode: '9814302375421836').first
		if (i.nil?)
			i = Item.new
			i.barcode = '9814302375421836'
			i.title = 'The Black Hole'
			i.author = 'Mark Twain'
			i.thickness = 3
			i.tray_id = Tray.where(barcode: 'TRAY-TYPE_ONE-1').first.id
			i.created_at = DateTime.now
			i.updated_at = DateTime.now
			i.bib_number = '000765020'
			i.isbn_issn = '0805779639'
			i.initial_ingest = DateTime.now
			i.disposition_id = Disposition.where(code: 'GREAT').first.id
			i.save!
		end
		puts 'Create 298745263018264836'
		i = Item.where(barcode: '298745263018264836').first
		if (i.nil?)
			i = Item.new
			i.barcode = '298745263018264836'
			i.title = 'Life of Brian'
			i.author = 'Mark Twain'
			i.thickness = 2
      i.tray_id = Tray.where(barcode: 'TRAY-TYPE_ONE-2').first.id
			i.created_at = DateTime.now
			i.updated_at = DateTime.now
			i.bib_number = '001068044'
			i.isbn_issn = '0521267293'
			i.initial_ingest = DateTime.now
			i.disposition_id = Disposition.where(code: 'GREAT').first.id
			i.save!
		end
		puts 'Create 498140984528174'
		i = Item.where(barcode: '498140984528174').first
		if i.nil?
      i = Item.new
      i.barcode = '498140984528174'
      i.title = 'Foundation'
      i.author = 'Mark Twain'
      i.thickness = 2
      i.tray_id = Tray.where(barcode: 'TRAY-TYPE_ONE-2').first.id
      i.created_at = DateTime.now
      i.updated_at = DateTime.now
      i.bib_number = '004708997'
      i.isbn_issn = '9780826273987'
      i.initial_ingest = DateTime.now
      i.disposition_id = Disposition.where(code: 'WRECKED').first.id
      i.save!
		end
		puts 'Create 0128374653527475632'
		i = Item.where(barcode: '0128374653527475632').first
		if (i.nil?)
			i = Item.new
			i.barcode = '0128374653527475632'
			i.title = 'Event Horizon'
			i.author = 'Dr. Worm Holeheimer'
			i.thickness = 2
			i.tray_id = Tray.where(barcode: 'TRAY-TYPE_ONE-2').first.id
			i.created_at = DateTime.now
			i.updated_at = DateTime.now
			i.bib_number = '001710311'
			i.isbn_issn = '0817309950'
			i.initial_ingest = DateTime.now
			i.disposition_id = Disposition.where(code: 'GREAT').first.id
			i.save!
		end
		puts 'Create 3916300254816378'
		i = Item.where(barcode: '3916300254816378').first
		if (i.nil?)
			i = Item.new
      i.barcode = '3916300254816378'
      i.title = 'Max and Moritz'
      i.author = 'Max and Moritz'
      i.thickness = 2
      i.tray_id = Tray.where(barcode: 'TRAY-TYPE_ONE-1').first.id
      i.created_at = DateTime.now
      i.updated_at = DateTime.now
      i.bib_number = '000357098'
      i.isbn_issn = '0520053370'
      i.initial_ingest = DateTime.now
      i.disposition_id = Disposition.where(code: 'GREAT').first.id
      i.save!
    end
		i = Item.where(barcode: '4304995837374878').first
		if (i.nil?)
			i = Item.new
      i.barcode = '4304995837374878'
      i.title = 'Beyond the lens of conservation : Malagasy and Swiss imaginations of one another'
      i.author = 'Eva Keller'
      i.thickness = 2
      i.tray_id = Tray.where(barcode: 'TRAY-TYPE_ONE-1').first.id
      i.created_at = DateTime.now
      i.updated_at = DateTime.now
      i.bib_number = '003877916'
      i.isbn_issn = '9781782385523'
      i.initial_ingest = DateTime.now
      i.disposition_id = Disposition.where(code: 'GREAT').first.id
      i.save!
    end
		i = Item.where(barcode: '391630045823451').first
		if (i.nil?)
			i = Item.new
      i.barcode = '391630045823451'
      i.title = 'Madagascar'
      i.author = 'Roland Fritz'
      i.thickness = 2
      i.tray_id = Tray.where(barcode: 'TRAY-TYPE_ONE-2').first.id
      i.created_at = DateTime.now
      i.updated_at = DateTime.now
      i.bib_number = '000631915'
      i.isbn_issn = '0080280021'
      i.initial_ingest = DateTime.now
      i.disposition_id = Disposition.where(code: 'GREAT').first.id
      i.save!
    end
		i = Item.where(barcode: '5493995838956373').first
		if (i.nil?)
			i = Item.new
      i.barcode = '5493995838956373'
      i.title = 'Extinct Madagascar : Picturing the Island Past'
      i.author = 'George Donaldson'
      i.thickness = 2
      i.tray_id = Tray.where(barcode: 'TRAY-TYPE_ONE-2').first.id
      i.created_at = DateTime.now
      i.updated_at = DateTime.now
      i.bib_number = '006199306'
      i.isbn_issn = '0226113310'
      i.initial_ingest = DateTime.now
      i.disposition_id = Disposition.where(code: 'GREAT').first.id
      i.save!
    end
		i = Item.where(barcode: '3916300593920398').first
		if (i.nil?)
			i = Item.new
      i.barcode = '3916300593920398'
      i.title = 'Historical dictionary of Madagascar'
      i.author = 'Philip Allen'
      i.thickness = 2
      i.tray_id = Tray.where(barcode: 'TRAY-TYPE_ONE-1').first.id
      i.created_at = DateTime.now
      i.updated_at = DateTime.now
      i.bib_number = '002182310'
      i.isbn_issn = '0810846365'
      i.initial_ingest = DateTime.now
      i.disposition_id = Disposition.where(code: 'GREAT').first.id
      i.save!
    end
  end
end

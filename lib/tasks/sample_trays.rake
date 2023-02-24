namespace :sample do
  desc "Add trays to the database"
  task :trays => :environment do
		puts 'Create TYPE ONE'
		tt = TrayType.where(code: "TYPE_ONE").first
		if (tt.nil?)
			tt = TrayType.new
			tt.trays_per_shelf = 5
			tt.height = 20
			tt.capacity = 10
			tt.code = "TYPE_ONE"
			tt.save!
		end
		puts 'Create TRAY-TYPE_ONE-1'
		t = Tray.where(barcode: "TRAY-TYPE_ONE-1").first
		if (t.nil?)
			t = Tray.new
			t.barcode = "TRAY-TYPE_ONE-1"
			t.shelf_id = Shelf.where(barcode: "SHELF-1").first.id
			t.tray_type_id = TrayType.where(code: "TYPE_ONE").first.id
			t.shelved = true
			t.save!
		end
		puts 'Create TRAY-TYPE_ONE-2'
		t = Tray.where(barcode: "TRAY-TYPE_ONE-2").first
		if (t.nil?)
			t = Tray.new
			t.barcode = "TRAY-TYPE_ONE-2"
			t.shelf_id = Shelf.where(barcode: "SHELF-1").first.id
			t.tray_type_id = TrayType.where(code: "TYPE_ONE").first.id
			t.shelved = true
			t.save!
		end
	end
end
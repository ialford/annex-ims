require "rails_helper"

feature "Shelves", type: :feature do
  include AuthenticationHelper

  before(:all) do
    FactoryBot.create(:tray_type, code: "AH")
    FactoryBot.create(:tray_type, code: "SHELF", unlimited: true)
  end

  describe "when signed in" do
    before(:each) do
      @shelf = FactoryBot.create(:shelf)
      @tray = FactoryBot.create(:tray, shelf: @shelf, barcode: "TRAY-#{@shelf.barcode}")
      @shelf2 = FactoryBot.create(:shelf)
      @tray2 = FactoryBot.create(:tray, shelf: @shelf2, barcode: "TRAY-#{@shelf2.barcode}")
      @item = FactoryBot.create(:item, barcode: "123456", thickness: 1, title: "ITEM 1", tray: @tray)
      @item2 = FactoryBot.create(:item, title: "ITEM 2")
      @tray2 = FactoryBot.create(:tray, barcode: "TRAY-AH11", shelf: @shelf2)
      @item3 = FactoryBot.create(:item, barcode: "1234567", tray: @tray2)

      login_admin

      item_uri = api_item_url(@item)
      response_body = {
        "item_id" => "00110147500410",
        "barcode" => @item.barcode,
        "bib_id" => @item.bib_number,
        "sequence_number" => "00410",
        "admin_document_number" => "001101475",
        "call_number" => @item.call_number,
        "description" => @item.chron,
        "title" => @item.title,
        "author" => @item.author,
        "publication" => "Cambridge, UK : Elsevier Science Publishers, c1991-",
        "edition" => "",
        "isbn_issn" => @item.isbn_issn,
        "condition" => @item.conditions,
        "sublibrary" => "ANNEX"
      }.to_json

      stub_request(:get, item_uri).
        with(headers: { "User-Agent" => "Faraday v0.17.0" }).
        to_return { { status: 200, body: response_body, headers: {} } }

      stub_request(:post, api_stock_url).
        with(body: { "barcode" => @item.barcode.to_s, "item_id" => @item.id.to_s, "tray_code" => @item.tray.barcode.to_s },
             headers: { "Content-Type" => "application/x-www-form-urlencoded", "User-Agent" => "Faraday v0.17.0" }).
        to_return { |_response| { status: 200, body: { results: { status: "OK", message: "Item stocked" } }.to_json, headers: {} } }
    end

    it "can scan a new shelf for processing items" do
      visit shelves_path
      fill_in "Shelf", with: @shelf.barcode
      click_button "Save"
      expect(current_path).to eq(show_shelf_path(id: @shelf.id))
    end

    it "can scan an item for adding to a shelf" do
      visit shelves_path
      fill_in "Shelf", with: @shelf.barcode
      click_button "Save"
      expect(current_path).to eq(show_shelf_path(id: @shelf.id))
      fill_in "Item", with: @item.barcode
      click_button "Save"
      expect(current_path).to eq(show_shelf_path(id: @shelf.id))
    end

    it "displays an item after successfully adding it to a shelf" do
      visit shelves_path
      fill_in "Shelf", with: @shelf.barcode
      click_button "Save"
      expect(current_path).to eq(show_shelf_path(id: @shelf.id))
      fill_in "Item", with: @item.barcode
      click_button "Save"
      expect(current_path).to eq(show_shelf_path(id: @shelf.id))
      expect(page).to have_content @item.barcode
      expect(page).to have_content @item.title
      expect(page).to have_content @item.chron
    end

    it "displays information about a successful association made" do
      visit shelves_path
      fill_in "Shelf", with: @shelf.barcode
      click_button "Save"
      expect(current_path).to eq(show_shelf_path(id: @shelf.id))
      @item.tray = nil
      @item.save!
      fill_in "Item", with: @item.barcode
      click_button "Save"
      expect(current_path).to eq(show_shelf_path(id: @shelf.id))
      expect(page).to have_content @item.barcode
      expect(page).to have_content @item.title
      expect(page).to have_content @item.chron
      expect(page).to have_content "Item #{@item.barcode} stocked in #{@shelf.barcode}."
    end

    it "accepts re-associating an item to the same shelf" do
      visit shelves_path
      fill_in "Shelf", with: @shelf.barcode
      click_button "Save"
      expect(current_path).to eq(show_shelf_path(id: @shelf.id))
      @item.tray = nil
      @item.save!
      fill_in "Item", with: @item.barcode
      click_button "Save"
      expect(current_path).to eq(show_shelf_path(id: @shelf.id))
      expect(page).to have_content @item.barcode
      expect(page).to have_content @item.title
      expect(page).to have_content @item.chron
      expect(page).to have_content "Item #{@item.barcode} stocked in #{@shelf.barcode}."
      fill_in "Item", with: @item.barcode
      click_button "Save"
      expect(current_path).to eq(show_shelf_path(id: @shelf.id))
      expect(page).to have_content @item.barcode
      expect(page).to have_content @item.title
      expect(page).to have_content @item.chron
      expect(page).to have_content "Item #{@item.barcode} already assigned to #{@shelf.barcode}. Record updated."
    end

    it "rejects associating an item to the wrong shelf" do
      visit shelves_path
      fill_in "Shelf", with: @shelf2.barcode
      click_button "Save"
      expect(current_path).to eq(show_shelf_path(id: @shelf2.id))
      fill_in "Item", with: @item.barcode
      click_button "Save"
      expect(current_path).to eq(wrong_shelf_item_path(id: @shelf2.id, barcode: @item.barcode))
      expect(page).to have_content "Item #{@item.barcode} is already assigned to #{@shelf.barcode}."
      expect(page).to have_content @item.barcode
      expect(page).to_not have_content @item.title
      expect(page).to_not have_content @item.chron
      expect(page).to_not have_content "Item #{@item.barcode} stocked in #{@shelf2.barcode}."
      click_button "OK"
      expect(current_path).to eq(show_shelf_path(id: @shelf2.id))
    end

    it "displays a shelf's barcode while processing an item" do
      visit shelves_path
      fill_in "Shelf", with: @shelf.barcode
      click_button "Save"
      expect(current_path).to eq(show_shelf_path(id: @shelf.id))
      fill_in "Item", with: @item.barcode
      click_button "Save"
      expect(current_path).to eq(show_shelf_path(id: @shelf.id))
      expect(page).to have_content @shelf.barcode
    end

    it "displays items associated with a shelf when processing items" do
      @items = []
      visit shelves_path
      fill_in "Shelf", with: @shelf.barcode
      click_button "Save"
      expect(current_path).to eq(show_shelf_path(id: @shelf.id))
      5.times do |i|
        item = FactoryBot.create(:item, title: "Item #{i + 1}")
        @items << item
        item_uri = api_item_url(item)
        response_body = {
          "item_id" => "00110147500410",
          "barcode" => item.barcode,
          "bib_id" => item.bib_number,
          "sequence_number" => "00410",
          "admin_document_number" => "001101475",
          "call_number" => item.call_number,
          "description" => item.chron,
          "title" => item.title,
          "author" => item.author,
          "publication" => "Cambridge, UK : Elsevier Science Publishers, c1991-",
          "edition" => "",
          "isbn_issn" => item.isbn_issn,
          "condition" => item.conditions,
          "sublibrary" => "ANNEX"
        }.to_json
        stub_request(:get, item_uri).
          with(headers: { "User-Agent" => "Faraday v0.17.0" }).
          to_return { { status: 200, body: response_body, headers: {} } }
        stub_request(:post, api_stock_url).
          with(body: { "barcode" => item.barcode.to_s, "item_id" => item.id.to_s, "tray_code" => "TRAY-#{@shelf.barcode}" },
               headers: { "Content-Type" => "application/x-www-form-urlencoded", "User-Agent" => "Faraday v0.17.0" }).
          to_return { |_response| { status: 200, body: { results: { status: "OK", message: "Item stocked" } }.to_json, headers: {} } }
        fill_in "Item", with: item.barcode
        click_button "Save"
        expect(current_path).to eq(show_shelf_path(id: @shelf.id))
      end
      @items.each do |item|
        expect(page).to have_content item.barcode
        expect(page).to have_content item.title
        expect(page).to have_content item.chron
      end
    end

    it "allows the user to remove an item from a shelf" do
      visit shelves_path
      fill_in "Shelf", with: @shelf.barcode
      click_button "Save"
      expect(current_path).to eq(show_shelf_path(id: @shelf.id))
      fill_in "Item", with: @item.barcode
      click_button "Save"
      expect(current_path).to eq(show_shelf_path(id: @shelf.id))
      expect(page).to have_content @item.barcode
      click_button "Remove"
      expect(current_path).to eq(show_shelf_path(id: @shelf.id))
      expect(page).to have_no_content @item.barcode
    end

    it "allows the user to finish with the current shelf when processing items" do
      visit shelves_path
      fill_in "Shelf", with: @shelf.barcode
      click_button "Save"
      expect(current_path).to eq(show_shelf_path(id: @shelf.id))
      fill_in "Item", with: @item.barcode
      click_button "Save"
      expect(current_path).to eq(show_shelf_path(id: @shelf.id))
      expect(page).to have_content @item.barcode
      click_button "Done"
      expect(current_path).to eq(shelves_path)
    end

    it "allows the user to finish with the current shelf when processing items via scan" do
      visit shelves_path
      fill_in "Shelf", with: @shelf.barcode
      click_button "Save"
      expect(current_path).to eq(show_shelf_path(id: @shelf.id))
      fill_in "Item", with: @item.barcode
      click_button "Save"
      expect(current_path).to eq(show_shelf_path(id: @shelf.id))
      expect(page).to have_content @item.barcode
      fill_in "Item", with: @shelf.barcode
      click_button "Save"
      expect(current_path).to eq(shelves_path)
    end

    it "displays information about the shelf the user just finished working with" do
      # pending "Not sure how to test this one yet, because when we're done it should leave that page and get ready for the next, I think."
    end
  end
end

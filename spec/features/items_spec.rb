require "rails_helper"

feature "Items", type: :feature do
  include AuthenticationHelper

  describe "when signed in" do
    before(:each) do
      login_admin

      @shelf = FactoryBot.create(:shelf)
      @tray = FactoryBot.create(:tray, shelf: @shelf)
      @tray2 = FactoryBot.create(:tray)
      @item = FactoryBot.create(:item, tray: @tray, thickness: 1, title: "The ubiquity of chaos / edited by Saul Krasner.", chron: "Chron")
      @item2 = FactoryBot.create(:item, tray: @tray2, thickness: 2, title: "The ubiquity of chaos / edited by Saul Krasner.", chron: "Chron")
      @user = FactoryBot.create(:user)
      @request = FactoryBot.create(:request)

      stub_request(:post, api_stock_url).
        with(body: { barcode: @item.barcode.to_s, item_id: @item.id.to_s, tray_code: @item.tray.barcode.to_s },
             headers: { "Content-Type" => "application/x-www-form-urlencoded", "User-Agent" => "Faraday v0.17.0" }).
        to_return(status: 200, body: { results: { status: "OK", message: "Item stocked" } }.to_json, headers: {})

      response_body = api_fixture_data("item_metadata.json")

      item_uri = api_item_url(@item)
      stub_request(:get, item_uri).
        with(headers: { "User-Agent" => "Faraday v0.17.0" }).
        to_return { { status: 200, body: response_body, headers: {} } }
    end

    context "stocking items" do
      it "can scan a new item" do
        visit items_path
        fill_in "Item", with: @item.barcode
        click_button "Find"
        expect(current_path).to eq(show_item_path(id: @item.id))
        expect(page).to have_content @item.title
        expect(page).to have_content @item.chron
      end

      it "can scan an item and then scan another item to change tasks" do
        visit items_path
        fill_in "Item", with: @item.barcode
        click_button "Find"
        expect(current_path).to eq(show_item_path(id: @item.id))
        fill_in "barcode", with: @item.barcode
        click_button "Scan"
        expect(current_path).to eq(show_item_path(id: @item.id))
        expect(page).to have_content @item.title
        expect(page).to have_content @item.chron
      end

      it "can scan an item and then scan a tray to stock it" do
        visit items_path
        fill_in "Item", with: @item.barcode
        click_button "Find"
        expect(current_path).to eq(show_item_path(id: @item.id))
        fill_in "barcode", with: @tray.barcode
        click_button "Scan"
        expect(current_path).to eq(items_path)
        expect(page).to have_content "Item #{@item.barcode} stocked in #{@tray.barcode}."
      end

      it "can scan an item and then scan a tray and show an error for the wrong tray" do
        visit items_path
        fill_in "Item", with: @item.barcode
        click_button "Find"
        expect(current_path).to eq(show_item_path(id: @item.id))
        fill_in "barcode", with: @tray2.barcode
        click_button "Scan"
        expect(current_path).to eq(wrong_restock_path(id: @item.id))
        expect(page).to have_content "Item #{@item.barcode} is already assigned to #{@tray.barcode}."
        click_button "OK"
        expect(current_path).to eq(show_item_path(id: @item.id))
      end
    end

    context "item issues" do
      it "can view a list of issues associated with retrieving item data" do
        @issues = []
        5.times do
          @issue = FactoryBot.create(:issue)
          @issues << @issue
        end
        visit issues_path
        @issues.each do |issue|
          expect(page).to have_content issue.user.username
          expect(page).to have_content issue.barcode
          expect(page).to have_content I18n.t("issues.issue_type.#{issue.issue_type}")
          expect(page).to have_content issue.created_at.strftime("%m-%d-%Y %I:%M%p")
        end
      end

      it "can view a list of issues associated with retrieving item data and delete them" do
        @issues = []
        5.times do
          item = FactoryBot.create(:item)
          @issue = FactoryBot.create(:issue, barcode: item.barcode)
          @issues << @issue
        end
        visit issues_path
        @issues.each do |issue|
          expect(page).to have_content issue.user.username
          expect(page).to have_content issue.barcode
          expect(page).to have_content I18n.t("issues.issue_type.#{issue.issue_type}")
          expect(page).to have_content issue.created_at.strftime("%m-%d-%Y %I:%M%p")
          click_button "issue-#{issue.id}"
          expect(current_path).to eq(issues_path)
          expect(page).to_not have_content issue.barcode
        end
      end
    end

    context "item details" do
      before(:each) do
        ActivityLogger.stock_item(item: @item, tray: @tray, user: @user)
        ActivityLogger.scan_item(item: @item, request: @request, user: @user)
        ActivityLogger.unstock_item(item: @item, tray: @tray, user: @user)
        ActivityLogger.stock_item(item: @item2, tray: @tray2, user: @user)
        ActivityLogger.ship_item(item: @item2, request: @request, user: @user)
        ActivityLogger.unstock_item(item: @item2, tray: @tray, user: @user)
      end

      it "displays item details" do
        visit item_detail_path(@item.barcode)
        expect(page).to have_content @item.status.humanize
        expect(page).to have_content @item.title
        expect(page).to have_content @item.author
        expect(page).to have_content @item.chron
      end

      it "displays item history" do
        visit item_detail_path(@item2.barcode)
        expect(page).to have_content "Stocked"
        expect(page).to have_content "Unstocked"
      end

      it "displays item usage" do
        visit item_detail_path(@item.barcode)
        expect(page).to have_content "Scanned"
        visit item_detail_path(@item2.barcode)
        expect(page).to have_content "Shipped"
      end

      it "has a link to its shelf" do
        visit item_detail_path(@item.barcode)
        click_link @item.tray.shelf.barcode.to_s
        expect(current_path).to eq(check_trays_path(barcode: @item.tray.shelf.barcode))
      end

      it "has a link to its tray" do
        visit item_detail_path(@item.barcode)
        click_link @item.tray.barcode.to_s
        expect(current_path).to eq(check_items_path(barcode: @item.tray.barcode))
      end
    end
  end
end

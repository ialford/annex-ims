require 'rails_helper'

feature "Trays on Shelf", type: :feature do
  include AuthenticationHelper

  let(:shelf) { FactoryGirl.create(:shelf) }

  describe "as an admin" do
    before(:each) do
      login_admin
      visit root_path
    end

    it "can see Trays on Shelf in the menu" do
      click_link "Quality Control"
      expect(page).to have_content "Trays on Shelf"
    end

    it "can access the Trays on Shelf page" do
      click_link "Quality Control"
      click_link "Trays on Shelf"
      expect(current_path).to eq(check_trays_new_path)
      expect(page).to have_content "Shelf Check Trays"
    end

    it "can accept a shelf barcode" do
      shelf
      visit check_trays_new_path
      fill_in "Shelf", with: shelf.barcode
      click_button "Save"
      expect(current_path).to eq(check_trays_path)
    end
  end
end

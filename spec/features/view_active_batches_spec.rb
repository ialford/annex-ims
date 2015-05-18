require 'rails_helper'

feature "View Active", :type => :feature do
  include AuthenticationHelper

  describe "when signed in" do

    let(:shelf) { FactoryGirl.create(:shelf) }
    let(:tray) { FactoryGirl.create(:tray, shelf: shelf) }
    let(:item) { FactoryGirl.create(:item, tray: tray, thickness: 1) }
    let(:request) { FactoryGirl.create(:request) }
    let(:batch) { FactoryGirl.create(:batch, user: @user, active: true) }
    let(:match) { FactoryGirl.create(:match, batch: batch, request: request, item: item) }

    before(:each) do
      login_user
      @match = match
    end

    after(:each) do
      Match.all.each do |match|
        match.destroy!
      end
      Batch.all.each do |batch|
        batch.destroy!
      end
    end

    it "can see processed batches" do
      visit view_active_batches_path
      expect(page).to have_content @match.batch.id
      expect(page).to have_content @match.batch.user.username
      expect(page).to have_content @match.batch.updated_at
    end

    it "can see details of a active batch" do
      visit view_single_active_batch_path(:id => @match.batch.id)
      expect(page).to have_content @match.batch.requests[0].title
      expect(page).to have_content @match.batch.requests[0].author
      expect(page).to have_content @match.batch.requests[0].source
      expect(page).to have_content @match.batch.requests[0].req_type
    end

    it "can see processed batches and cancel one" do
      visit view_active_batches_path
      expect(page).to have_content @match.batch.id
      expect(page).to have_content @match.batch.user.username
      expect(page).to have_content @match.batch.updated_at
      click_button "Cancel"
      expect(current_path).to eq(view_active_batches_path)
      expect(page).to have_content "No active batches."
    end

    it "can see details of a active batch and cancel it" do
      visit view_single_active_batch_path(:id => @match.batch.id)
      expect(page).to have_content @match.batch.requests[0].title
      expect(page).to have_content @match.batch.requests[0].author
      expect(page).to have_content @match.batch.requests[0].source
      expect(page).to have_content @match.batch.requests[0].req_type
      click_button "Cancel"
      expect(current_path).to eq(view_active_batches_path)
      expect(page).to have_content "No active batches."
    end

  end
end

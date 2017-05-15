require 'rails_helper'

RSpec.describe DeaccessioningController, type: :controller do
  let(:user) { FactoryGirl.create(:user, admin: true) }
  let(:item) { FactoryGirl.create(:item) }
  let!(:disposition) { FactoryGirl.create(:disposition) }
  let!(:comment) { "Test comment" }

  before(:each) do
    sign_in(user)
  end

  describe "GET index" do
    context "admin" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "POST req" do
    subject do
      post :req, items: {"#{item.id}" => "items[#{item.id}]"},
	   disposition_id: disposition.id,
           comment: comment
    end
    it "builds a deaccessioning request" do
      expect(BuildDeaccessioningRequest).to receive(:call).
	with(item.id.to_s, nil, nil)
      subject
    end

    it "redirects to batches path" do
      subject
      expect(response).to redirect_to(batches_path)
    end
  end
end

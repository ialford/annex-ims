require "rails_helper"

describe "DestroyRequest" do

  let(:request) { FactoryGirl.create(:request) }
  let(:request1) { FactoryGirl.create(:request) }
  let(:user) { FactoryGirl.create(:user) }
  subject { DestroyRequest.call(request, user)}

  describe "#destroy" do

    before(:each) do
      request.save!
      request1.save!
    end

    it "deletes one request" do
      expect(Request.all.count).to eq 2
      subject
      expect(Request.all.count).to eq 1
    end
    
  end

end
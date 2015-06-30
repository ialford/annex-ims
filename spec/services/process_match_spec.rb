require "rails_helper"

RSpec.describe ProcessMatch do
  let(:shelf) { FactoryGirl.create(:shelf) }
  let(:tray) { FactoryGirl.create(:tray, shelf: shelf) }
  let(:item) { FactoryGirl.create(:item, tray: tray, thickness: 1) }
  let(:bin) { FactoryGirl.create(:bin, items: [item]) }
  let(:match) { FactoryGirl.create(:match, item: item, bin: bin, request: request) }
  let(:user) { FactoryGirl.create(:user) }
  let(:request) { FactoryGirl.create(:request, del_type: "loan") }

  subject { described_class.call(match: match, user: user) }

  it "processes a match" do
    expect(subject).to eq(true)
  end

  it "dissociates the bin" do
    subject
    expect(match.bin).to be_nil
    expect(item.bin).to be_nil
  end

  it "ships the item" do
    expect(ShipItem).to receive(:call).with(item, user)
    subject
  end

  context "scan request" do
    let(:request) { FactoryGirl.create(:request, del_type: "scan") }

    it "scans the item" do
      expect(ScanItem).to receive(:call).with(item, user).and_call_original
      subject
    end
  end

  it "notifies the API" do
    expect(ApiScanSendJob).to receive(:perform_later).with(match: match)
    subject
  end
end

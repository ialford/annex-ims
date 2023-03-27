require 'rails_helper'

RSpec.describe ProcessMatch do
  let(:shelf) { create(:shelf) }
  let(:tray) { create(:tray, shelf: shelf) }
  let(:item) { create(:item, tray: tray, thickness: 1) }
  let(:bin) { create(:bin, items: [item]) }
  let(:match) { create(:match, item: item, bin: bin, request: request) }
  let(:user) { create(:user) }
  let(:request) { create(:request, del_type: 'loan') }

  subject { described_class.call(match: match, user: user) }

  it 'processes a match' do
    expect(subject).to eq(true)
  end

  it 'ships the item' do
    expect(ShipItem).to receive(:call).with(item: item, request: request, user: user).and_call_original
    subject
  end

  context 'scan request' do
    let(:request) { create(:request, del_type: 'scan') }

    it 'scans the item' do
      expect(ScanItem).to receive(:call).with(item: item, request: request, user: user).and_call_original
      subject
    end
  end

  it 'notifies the API' do
    expect(ApiScanSendJob).to receive(:perform_later).with(match: match)
    subject
  end

  it 'completes the match' do
    expect(match).to receive('processed=').with('completed')
    subject
  end

  it 'completes the request if it was the last match in that request' do
    expect(CompleteRequest).to receive(:call)
    subject
  end
end

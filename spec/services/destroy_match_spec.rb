require 'rails_helper'

RSpec.describe DestroyMatch do
  let(:shelf) { create(:shelf) }
  let(:tray) { create(:tray, shelf: shelf) }
  let(:item) { create(:item, tray: tray, thickness: 1) }
  let(:bin) { create(:bin, items: [item]) }
  let(:match) { create(:match, item: item, bin: bin, request: request) }
  let(:batch) { create(:batch, user: user) }
  let(:match1) { create(:match, batch: batch) }
  let(:match2) { create(:match, batch: batch) }
  let(:match3) { create(:match, batch: batch) }
  let(:user) { create(:user) }
  let(:request) { create(:request, del_type: 'loan') }

  subject { described_class.call(match: match, user: user) }

  it 'is truthy' do
    expect(subject).to be_truthy
  end

  it 'logs a RemovedMatch activity' do
    expect(ActivityLogger).to receive(:remove_match)
    subject
  end

  it 'destroys the match' do
    expect(match).to receive(:destroy!)
    subject
  end
end

require "rails_helper"

RSpec.describe ShelfFull do
  before(:all) do
    create(:tray_type)
  end

  it "indicates that a shelf that is empty shows as empty" do
    @shelf = create(:shelf)
    results = ShelfFull.call(@shelf)
    expect(results).to eq(ShelfFull::EMPTY)
  end

  it "indicates that a shelf that is definitely not full shows as not full" do
    @tray = create(:tray)
    @shelf = create(:shelf, trays: [@tray])
    results = ShelfFull.call(@shelf)
    expect(results).to eq(ShelfFull::PARTIAL)
  end

  it "indicates that a shelf that is exactly full shows as full" do
    @tray = create(:tray)
    @shelf = create(:shelf)
    @tray.tray_type.trays_per_shelf.times do
      create(:tray, shelf: @shelf)
    end
    results = ShelfFull.call(@shelf)
    expect(results).to eq(ShelfFull::FULL)
  end

  it "indicates that a shelf that is over full shows as over" do
    @tray = create(:tray)
    @shelf = create(:shelf)
    (@tray.tray_type.trays_per_shelf + 1).times do
      create(:tray, shelf: @shelf)
    end
    results = ShelfFull.call(@shelf)
    expect(results).to eq(ShelfFull::OVER)
  end
end

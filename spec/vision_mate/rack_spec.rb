require_relative "../../lib/vision_mate/rack"
require_relative "../../lib/vision_mate/tube"
require_relative "../../lib/vision_mate/no_tube"

describe VisionMate::Rack do
  subject { VisionMate::Rack.new(one_tube_string) }
  let(:position_with_tube) { "H1" }
  let(:position_without_tube) { "A1" }
  let(:out_of_range_position) { "Z100" }

  it "behaves like an array of tubes" do
    expect(subject.to_a.count).to eq 96
  end

  it "assigns the correct positions to tubes" do
    rack = VisionMate::Rack.new(full_rack_string)
    first_tube = rack.at_position("A1")
    middle_tube = rack.at_position("D6")
    last_tube = rack.at_position("H12")
    expect(first_tube.barcode).to eq "0093404458"
    expect(middle_tube.barcode).to eq "0093404519"
    expect(last_tube.barcode).to eq "0093404468"
  end

  describe "#at_position" do
    it "can find a tube at a position" do
      tube = subject.at_position position_with_tube
      expect(tube).not_to be_empty
    end

    it "returns a NoTube object at a posistion with no tube" do
      tube = subject.at_position position_without_tube
      expect(tube).to be_empty
    end

    it "raises an error when a tube is not found at position" do
      expect do
        subject.at_position out_of_range_position
      end.to raise_error(VisionMate::Rack::PositionOutOfRange)
    end
  end

  describe "#empty?" do
    it "is empty if there are no tubes in it" do
      rack = VisionMate::Rack.new(no_tube_string)
      expect(rack).to be_empty
    end

    it "is not empty if there are any tubes" do
      rack = VisionMate::Rack.new(one_tube_string)
      expect(rack).not_to be_empty
    end
  end

  def no_tube_string
    read_tube_file "/assets/empty_tube_results.txt"
  end

  def one_tube_string
    read_tube_file "/assets/one_tube_results.txt"
  end

  def full_rack_string
    read_tube_file "/assets/full_rack_results.txt"
  end

  def read_tube_file(path)
    gem_path = File.expand_path('../..', __FILE__)
    asset_path = gem_path + path
    File.read(asset_path)[/OK(.*)/, 1]
  end
end

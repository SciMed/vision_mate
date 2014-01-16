require_relative "../../lib/vision_mate/tube"

describe VisionMate::Tube do
  describe "#barcode" do
    it "returns a barcode" do
      tube = VisionMate::Tube.new "foo-barcode", "A1"
      expect(tube.barcode).to eq "foo-barcode"
    end
  end

  describe "#position" do
    it "returns it's own position" do
      tube = VisionMate::Tube.new "foo-barcode", "A1"
      expect(tube.position).to eq "A1"
    end
  end
end

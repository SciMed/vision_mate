require_relative "../../lib/vision_mate/tube"
require_relative "../../lib/vision_mate/no_tube"

describe VisionMate::Tube do
  describe ".create" do
    it "returns a tube object if there is a barcode" do
      expect(VisionMate::Tube.create("NOOP", "A2")).not_to be_empty
    end

    it "returns a tube object if the barcode is No Tube" do
      expect(VisionMate::Tube.create("No Tube", "A2")).to be_empty
    end
  end

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

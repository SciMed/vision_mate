require_relative "../../lib/vision_mate/connection"

class VisionMate::Telnet; end

class VisionMate::Rack; end

describe VisionMate::Connection do
  let(:uri) { double("uri", host: "192.168.3.132", port: "8000") }

  describe "#scan" do
    subject { VisionMate::Connection.new uri.host, uri.port }
    let(:rack_size) { 96 }

    it "returns an rack" do
      VisionMate::Telnet.stub connect: double("telnet", scan: "NOOP")
        # .with("String" => "D", "Match" => /OK/)
        # .and_return(one_tube_string)
      VisionMate::Rack.stub new: double("rack", empty?: false)
      rack = subject.scan
      expect(rack).not_to be_empty
    end
  end
end

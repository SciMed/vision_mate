require_relative "../../lib/vision_mate/connection"
require 'uri'

class VisionMate::NoTube; end
class VisionMate::Tube; end
class MockTelnet;
  def initialize(*); end
end

describe VisionMate::Connection do
  let(:uri) { double("uri", host: "192.168.3.132", port: "8000") }

  describe "#scan" do
    subject { VisionMate::Connection.new uri.host, uri.port, MockTelnet }
    let (:rack_size) { 96 }

    context "no tubes in the rack" do
      it "returns and empty rack" do
        subject.telnet_connection.should_receive(:cmd)
          .with("String"=> "D", "Match" => /OK/)
          .and_return(empty_tube_string)
        VisionMate::NoTube.stub new: double("no_tube", empty?: true)
        VisionMate::Tube.stub new: double("tube", empty?: false)
        rack = subject.scan
        expect(rack.reject(&:empty?)).to be_empty
      end
    end

    context "one tube in rack" do
      it "returns a rack with one tube" do
        subject.telnet_connection.should_receive(:cmd)
          .with("String"=> "D", "Match" => /OK/)
          .and_return(one_tube_string)
        VisionMate::NoTube.stub new: double("no_tube", empty?: true)
        VisionMate::Tube.stub new: double("tube", empty?: false)
        rack = subject.scan
        expect(rack.reject(&:empty?).count).to eq 1
      end
    end
  end

  def empty_tube_string
    "OKNo Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,"
  end

  def one_tube_string
    "OKNo Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,0093404544,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,"
  end
end

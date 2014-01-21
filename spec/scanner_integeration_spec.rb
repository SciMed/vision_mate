require_relative "../lib/vision_mate"
require "net/telnet"

class MockTelnet
  def initialize(*); end
end

describe "Integrating With a Scanner" do
  let(:telnet) { double("telnet") }
  before(:each) do
    telnet.stub(:cmd).with(hash_including("String" => "M0"))
    telnet.stub(:cmd).with(hash_including("String" => "S"))
    telnet.stub(:cmd).with(hash_including("String" => "D"))
      .and_return one_tube_string
    telnet.stub(:cmd).with(hash_including("String" => "L")).and_return("OK37")
    Net::Telnet.stub new: telnet
  end

  it "scans a rack of tubes" do
    VisionMate.configure do |config|
      config.host = "http://192.168.3.132"
      config.port = "8000"
    end
    vm_client = VisionMate.connect
    result = vm_client.scan.reject(&:empty?)
    expect(result.first.barcode).to eq first_tube_barcode
    expect(result.first.position).to eq first_tube_position
  end

  it "throws an error for no read" do
    telnet.stub(:cmd).with(hash_including("String" => "D"))
      .and_return bad_read_string
    VisionMate.configure do |config|
      config.host = "http://192.168.3.132"
      config.port = "8000"
    end

    vm_client = VisionMate.connect
    expect { vm_client.scan }.to raise_error(
      VisionMate::Telnet::TubeReadError
    )
  end

  def first_tube_position
    "H1"
  end

  def first_tube_barcode
    "0093404544"
  end

  def bad_read_string
    one_tube_string.sub(/No Tube/, "No Read")
  end

  def one_tube_string
    gem_path = File.expand_path('../..', __FILE__)
    asset_path = gem_path + "/spec/assets/one_tube_results.txt"
    File.read(asset_path)
  end
end

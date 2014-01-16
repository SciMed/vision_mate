require_relative "../lib/vision_mate"
require "net/telnet"

class MockTelnet
  def initialize(*); end
end

describe "Integrating With a Scanner" do
  before(:each) { Net::Telnet.stub new: double("telnet") }
  it "scans a rack of tubes" do
    VisionMate.configure do |config|
      config.host = "http://192.168.3.132"
      config.port = "8000"
    end
    vm_client = VisionMate.connect
    vm_client.telnet_connection.stub(cmd: one_tube_string)
    result = vm_client.scan.reject(&:empty?)
    expect(result.first.barcode).to eq first_tube_barcode
    expect(result.first.position).to eq first_tube_position
  end

  def first_tube_position
    "H1"
  end

  def first_tube_barcode
    "0093404544"
  end

  def one_tube_string
    gem_path = File.expand_path('../..', __FILE__)
    asset_path = gem_path + "/spec/assets/one_tube_results.txt"
    File.read(asset_path)
  end
end

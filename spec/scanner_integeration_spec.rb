require_relative "../lib/vision_mate"
require "net/telnet"

class MockTelnet;
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
  end

  def first_tube_barcode
    "0093404544"
  end

  def one_tube_string
    "OKNo Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,0093404544,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,No Tube,"
  end
end

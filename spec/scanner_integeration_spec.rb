require_relative "../lib/vision_mate"
require "uri"

describe "Integrating With a Scanner" do
  it "scans a rack of tubes" do
    VisionMate.config do |config|
      config.host = "http://192.168.3.132"
      config.port = "8000"
    end
    vm_client = VisionMate.connect
    results = vm_client.scan
    expect(results.first.barcode).to be first_tube_barcode
  end
end

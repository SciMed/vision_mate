require_relative "../lib/vision_mate"
require "uri"

describe "Integrating With a Scanner" do
  it "scans a rack of tubes" do
    host = URI.parse("http://192.168.3.132:8000")
    vm_client = VisionMate.connect(host)
    results = vm_client.scan
    expect(results.first.barcode).to be first_tube_barcode
  end
end

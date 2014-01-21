require_relative "../../lib/vision_mate/telnet"

class MockTelnet; end

describe VisionMate::Telnet do
  subject { VisionMate::Telnet.new(telnet_connection) }
  let(:uri) { double("uri", host: "192.168.3.132", port: "8000") }
  let(:telnet_connection) { double "telnet_connection" }

  describe ".connect" do
    it "connects to telnet using a host and port" do
      MockTelnet.should_receive(:new)
        .with(hash_including("Host" => uri.host, "Port" => uri.port))
        .and_return double("telnet_connection").as_null_object

      VisionMate::Telnet.connect(uri.host, uri.port, MockTelnet)
    end

    it "thows an exception if it cannot connect" do
      MockTelnet.stub(:new).and_raise(Timeout::Error)
      expect {
        VisionMate::Telnet.connect("bad_host.com", "88", MockTelnet)
      }.to raise_error(VisionMate::Telnet::CouldNotConnect)
    end

    it "throws an exception if the port or host is invalid" do
      MockTelnet.stub(:new).and_raise(SocketError)
      expect {
        VisionMate::Telnet.connect("bad_host", "899999", MockTelnet)
      }.to raise_error(VisionMate::Telnet::BadHostNameOrPort)
    end

    it "sets the scanner to manual" do
      MockTelnet.stub(new: telnet_connection)
      telnet_connection.should_receive(:cmd).with("String" => "M0", "Match" => /OK/)
      VisionMate::Telnet.connect("foo.com", "80", MockTelnet)
    end
  end

  describe "#scan" do
    before do
      telnet_connection.stub(:cmd).with("String" => "L", "Match" => /OK/)
        .and_return("OK45")
    end

    it "scans and returns a string of barcodes and no bacodes" do
      telnet_connection.should_receive(:cmd).with("String" => "M0", "Match" => /OK/)
      telnet_connection.should_receive(:cmd).with("String" => "S", "Match" => /OK/)
      telnet_connection.should_receive(:cmd).with("String" => "L", "Match" => /OK/)
      telnet_connection.should_receive(:cmd).with("String" => "D", "Match" => /OK/)
        .and_return one_tube_results
      return_value = subject.scan
      expect(return_value).to match /0093404544/
      expect(return_value).to match /No Tube/
    end

    it "raises an error if there are no reads" do
      telnet_connection.stub cmd: "OK45"
      subject.stub(:retrieve_data).and_return(no_read_results)
      expect { subject.scan }.to raise_error(VisionMate::Telnet::TubeReadError)
    end
  end

  describe "#initate_scan" do
    it "waits for the data to be ready to retrieve it" do
      start_time = Time.now
      telnet_connection.stub(:cmd) do |command|
        if command["String"] == "L" && (Time.now - start_time) <= 0.1
          "OK35"
        else
          "OK45"
        end
      end

      subject.should_receive(:retrieve_data).and_return "OKSome Data"
      subject.scan
    end
  end

  def no_read_results
    one_tube_results.sub(/No Tube/, "No Read")
  end

  def one_tube_results
    read_tube_file "/assets/one_tube_results.txt"
  end

  def read_tube_file(path)
    gem_path = File.expand_path('../..', __FILE__)
    asset_path = gem_path + path
    File.read(asset_path)
  end
end

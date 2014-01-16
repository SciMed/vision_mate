require_relative "../lib/vision_mate"
require "uri"

class VisionMate::Connection
  def initialize(*); end
end

describe VisionMate do
  describe ".config" do
    it "can set the connection host" do
      VisionMate.config do |config|
        config.host = "http://192.168.3.132"
      end
      VisionMate::Configuration.host.should == "http://192.168.3.132"
    end

    it "can set the connection port" do
      VisionMate.config do |config|
        config.port = "8000"
      end
      VisionMate::Configuration.port.should == "8000"
    end
  end

  describe ".connect" do
    it "returns a connection object with the host" do
      host = URI "http://foo.com:90"
      VisionMate::Connection.any_instance.stub host: host
      connection = subject.connect host
      expect(connection.host).to eq host
     end

    it "returns a connection object when given a URI string" do
      host = "http://foo.com:90"
      VisionMate::Connection.should_receive(:new).with(duck_type(:host, :port))
      connection = subject.connect host
    end
  end
end

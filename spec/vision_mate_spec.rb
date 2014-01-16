require_relative "../lib/vision_mate"

describe VisionMate do
  describe ".configure" do
    it "can set the connection host" do
      VisionMate.configure do |config|
        config.host = "http://192.168.3.132"
      end
      VisionMate::Configuration.host.should == "http://192.168.3.132"
    end

    it "can set the connection port" do
      VisionMate.configure do |config|
        config.port = "8000"
      end
      VisionMate::Configuration.port.should == "8000"
    end
  end

  describe ".connect" do
    it "returns a connection object with the host" do
      VisionMate::Configuration.stub host: "host"
      VisionMate::Connection.stub new: double("connection", host: "host")
      connection = subject.connect
      expect(connection.host).to eq "host"
    end
  end
end

require_relative "../lib/vision_mate"

class VisionMate::Connection
  def initialize(*); end
end

describe VisionMate do
  describe "#connect" do
    it "returns a connection object with the host" do
      host = double("host", host: "foo.com", port: "90")
      VisionMate::Connection.any_instance.stub host: host
      connection = subject.connect host
      expect(connection.host).to eq host
    end
  end
end

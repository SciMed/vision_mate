module VisionMate
  # Connection is an abstract interface used to wrap the Telnet connection to
  # the scanner. It provides a high level API for the scanner and standardizes
  # the output returned.
  #
  class Connection
    attr_accessor :telnet_connection

    def initialize(host, port, telnet_class = Telnet)
      self.telnet_connection = Telnet.connect(host, port)
    end

    def scan
      VisionMate::Rack.new(telnet_connection.scan)
    end

    def close
      telnet_connection.close
    end
  end
end

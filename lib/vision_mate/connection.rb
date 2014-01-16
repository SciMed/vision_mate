require "net/telnet"

module VisionMate
  # Connection is an abstract interface used to wrap the Telnet connection to
  # the scanner. It provides a high level API for the scanner and standardizes
  # the output returned.
  #
  class Connection
    attr_accessor :telnet_connection, :host, :port

    def initialize(host, port, telnet_class = Net::Telnet)
      self.host = host
      self.port = port
      self.telnet_connection = telnet_class.new(
        "Host" => host, "Port" => port
      )
    end

    def scan
      response = telnet_connection.cmd("String" => "D", "Match" => /OK/)
      build_rack(response)
    end

    private

    def build_rack(response)
      response[/\AOK(.+)/, 1].split(",").compact.map do |tube|
        build_tube(tube)
      end
    end

    def build_tube(barcode)
      return NoTube.new(barcode, "TODO Position") if barcode == "No Tube"
      # TODO: Set Posistions
      Tube.new(barcode, "H1")
    end
  end
end

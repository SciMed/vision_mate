require "net/telnet"

module VisionMate
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
        response[/\AOK(.+)/, 1].split(",").compact.map { |tube|
          build_tube(tube)
        }
      end

      def build_tube(barcode)
        return NoTube.new(barcode, "TODO Position") if barcode == "No Tube"

        # TODO: Set Posistions
        Tube.new(barcode, "H1")
      end
  end
end

require "net/telnet"

module VisionMate
  class Telnet
    attr_accessor :telnet_connection
    class CouldNotConnect < StandardError; end
    class BadHostNameOrPort < StandardError; end
    class TubeReadError < StandardError; end

    # For ruby 1.9 compatibility
    class Net::OpenTimeout; end

    def self.connect(host, port, telnet_class = Net::Telnet)
      new(telnet_class.new("Host" => host, "Port" => port))
    rescue Net::OpenTimeout, Timeout::Error
      raise CouldNotConnect, "Failed to connect to #{host}:#{port}"
    rescue SocketError
      raise BadHostNameOrPort, "Malformed host name or port"
    end

    def initialize(telnet_connection)
      self.telnet_connection = telnet_connection
      set_scanner_to_manual
    end

    def scan
      initiate_scan
      result = retrieve_data
      raise TubeReadError, "One or more tubes not read" if result[/No Read/]
      strip_prefix(result)
    end

    def initiate_scan
      telnet_connection.cmd("String" => "S", "Match" => /OK/)
      sleep 0.1 until scanner_status["data_ready"]
    end

    private

      def scanner_status
        status = strip_prefix(telnet_connection.cmd("String" => "L", "Match" => /OK/))
        status_names = %w{initializing scanning finished_scan data_ready data_sent
          rack96 empty error}
        status_values = extract_statuses(status)

        Hash[status_names.zip(status_values)]
      end

      def extract_statuses(status)
        to_binary_string(status.to_i).split('').map { |status| status == "1" }
      end

      def to_binary_string(int)
        int.to_s(2)
      end

      def retrieve_data
        telnet_connection.cmd("String" => "D", "Match" => /OK/)
      end

      def set_scanner_to_manual
        telnet_connection.cmd("String" => "M0", "Match" => /OK/)
      end

      def strip_prefix(string)
        string[/^OK(.*)/, 1]
      end
  end
end

require "net/telnet"

module VisionMate
  class Telnet
    attr_accessor :telnet_connection
    class CouldNotConnect < StandardError; end
    class BadHostNameOrPort < StandardError; end
    class TubeReadError < StandardError; end

    # For ruby 1.9 compatibility
    class Net::OpenTimeout; end
    class Net::ReadTimeout; end

    def self.connect(host, port, telnet_class = Net::Telnet)
      if host.blank? || port.blank?
        raise BadHostNameOrPort, "No host or port specified for Telnet connection"
      end
      telnet_connection = verified_connection host, port, telnet_class
      new(telnet_connection)
    rescue Net::OpenTimeout, Timeout::Error
      raise CouldNotConnect, "Failed to connect to #{host}:#{port}"
    rescue SocketError
      raise BadHostNameOrPort, "Malformed host name or port"
    end

    def self.verified_connection(host, port, telnet_class)
      telnet_connection = telnet_class.new(
        "Host" => host, "Port" => port, "Timeout" => Configuration.timeout
      )
      telnet_connection.cmd("String" => "L", "Match" => /OK/)

      telnet_connection
    rescue Net::OpenTimeout, Timeout::Error => e
      retries ||= 0
      raise e if retries == 5
      retries += 1
      retry
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
      telnet_command("S")
      wait_for_data
    end

    def close
      telnet_connection.close
    end

    private

    def telnet_command(string)
      telnet_connection.cmd("String" => string, "Match" => /OK/)
    rescue Net::ReadTimeout, Timeout::Error
      retries ||= 0
      raise CouldNotConnect, "Telnet command timed out: #{string}" if retries == 5
      retries += 1
      retry
    end

    def wait_for_data
      sleep 1
      while true
        status = scanner_status
        break if !status["scanning"] && status["data_ready"]
        sleep 0.1
      end
    end

    def scanner_status
      result = telnet_command "L"
      status = strip_prefix(result)
      status_names = %w{error empty rack96 data_sent data_ready finished_scan scanning initializing}
      status_values = extract_statuses(status)

      Hash[status_names.zip(status_values)]
    end

    def extract_statuses(status_string)
      statuses = to_binary_string(status_string.to_i).split('')

      statuses.map { |status| status == "1" }
    end

    def to_binary_string(int)
      int.to_s(2).rjust(8,"0")
    end

    def retrieve_data
      telnet_command "D"
    end

    def set_scanner_to_manual
      telnet_command "M0"
    end

    # The OK is followed by the command value then possibly a response value.
    # E.g. if you send an "L" the response will be "OKL61"
    def strip_prefix(string)
      string[/^OK.(.*)/, 1]
    end
  end
end

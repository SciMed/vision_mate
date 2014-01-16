require "vision_mate/configuration"
require "vision_mate/connection"
require "vision_mate/version"
require "uri"

module VisionMate
  # Used to configure long lived information needed throughout the scanning
  # process. Provides access to `host` and `port` along with other information
  # used to configure the orientation and dimensions of scanned racks.
  #
  # Example:
  #     VisionMate.configure do |config|
  #       config.host = "192.168.1.1"
  #       config.port = "8080"
  #     end
  #
  #     VisionMate::Configuration.host # => "192.168.1.1"
  #     VisionMate::Configuration.port # => "8080"
  #
  def self.configure(&block)
    block.call(VisionMate::Configuration)
  end

  def self.connect
    host = Configuration.host
    port = Configuration.port
    Connection.new(host, port)
  end
end

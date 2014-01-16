require "vision_mate/version"
require "vision_mate/configuration"

module VisionMate
  # Used to configure long lived information needed throughout the scanning
  # process. Provides access to `host` and `port` along with other information
  # used to configure the orientation and dimensions of scanned racks.
  #
  # Example:
  #     VisionMate.config do |config|
  #       config.host = "192.168.1.1"
  #       config.port = "8080"
  #     end
  #
  #     VisionMate::Configuration.host # => "192.168.1.1"
  #     VisionMate::Configuration.port # => "8080"
  #
  def self.config(&block)
    block.call(VisionMate::Configuration)
  end

  def self.connect
    host = Configuration.host
    Connection.new(host)
  end
end

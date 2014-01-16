require "vision_mate/version"
require "vision_mate/connection"
require "uri"

module VisionMate
  def self.connect(host)
    Connection.new(host)
  end
end

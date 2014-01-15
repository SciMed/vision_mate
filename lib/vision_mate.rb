require "vision_mate/version"

module VisionMate
  def self.connect(host)
    host = URI(host)
    Connection.new(host)
  end
end

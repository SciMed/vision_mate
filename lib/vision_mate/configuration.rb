module VisionMate
  # The Configuration provides access to long lived information needed
  # throughout the scanning process.
  #
  module Configuration
    class << self
      attr_accessor :host, :port
    end
  end
end

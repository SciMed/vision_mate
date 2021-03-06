module VisionMate
  # Tube provides barcode and other meta information for each individual test
  # tube inside the rack. Tube's are usually returned as a collection within
  # a `Rack` object once a scan is performed.
  #
  class Tube
    attr_accessor :barcode, :position

    def self.create(barcode, position)
      return NoTube.new(barcode, position) if barcode == "No Tube"

      Tube.new(barcode, position)
    end

    def initialize(barcode, position)
      self.barcode = barcode
      self.position = position
    end

    def empty?
      false
    end
  end
end

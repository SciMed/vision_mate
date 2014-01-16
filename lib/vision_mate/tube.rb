module VisionMate
  class Tube
    attr_accessor :barcode, :position

    def initialize(barcode, position)
      self.barcode = barcode
      self.position = position
    end

    def empty?
      false
    end
  end
end

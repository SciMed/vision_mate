module VisionMate
  class Tube
    attr_accessor :barcode

    def initialize(barcode)
      self.barcode = barcode
    end

    def empty?
      false
    end
  end
end

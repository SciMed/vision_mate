module VisionMate
  class NoTube
    attr_accessor :barcode, :position

    def initialize(_, position)
      self.position = position
    end

    def empty?
      true
    end
  end
end

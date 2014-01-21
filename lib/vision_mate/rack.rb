module VisionMate
  class Rack
    include Enumerable
    attr_accessor :tubes, :number_of_rows, :number_of_columns

    class PositionOutOfRange < StandardError; end

    def initialize(tube_string)
      self.number_of_rows = 8
      self.number_of_columns = 12
      self.tubes = new_rack(tube_string)
    end

    def each(&block)
      tubes.each(&block)
    end

    def at_position(position)
      tubes.find { |tube| tube.position == position } ||
        raise(PositionOutOfRange)
    end

    def empty?
      tubes.all?(&:empty?)
    end

    private

    def new_rack(tube_string)
      tube_strings = tube_string.split(",").compact
      tube_strings.each_with_index.map do |barcode, position|
        Tube.create barcode, converted_position(position)
      end
    end

    def converted_position(position)
      row_letters = ("A".."Z").take(number_of_rows)
      row_letter = row_letters[position % number_of_rows]
      row_number = (position / number_of_rows) + 1

      "#{row_letter}#{row_number}"
    end
  end
end

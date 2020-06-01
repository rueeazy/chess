class Knight
    attr_accessor :incremental_moves, :ending_positions, :possible_positions
    
    def initialize(color)
        @color = color
        @possible_positions = []
        @incremental_moves = [[-2, 1], [-1, 2], [1, 2], [2, 1],
                             [2, -1], [1, -2], [-1, -2], [-2, -1]].freeze
        @ending_positions = [[-2, 1], [-1, 2], [1, 2], [2, 1],
                 [2, -1], [1, -2], [-1, -2], [-2, -1]].freeze
    end

    def to_s
        if @color == "black"
            "\u{2658}"
        elsif @color == "white"
            "\u{265E}"
        end
    end
end 
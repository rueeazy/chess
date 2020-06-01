class King
    attr_accessor :incremental_moves, :ending_positions, :possible_positions
    
    def initialize(color)
        @color = color
        @possible_positions = []
        @incremental_moves = [[[0,1], [1,1], [1,0], [1,-1],
                             [0,-1], [-1,-1], [-1,0], [-1,1]].freeze]
        @ending_positions = [[0,1], [1,1], [1,0], [1,-1],
                 [0,-1], [-1,-1], [-1,0], [-1,1]].freeze
    end

    def to_s
        if @color == "black"
            "\u{2654}"
        elsif @color == "white"
            "\u{265A}"
        end
    end
    
end 
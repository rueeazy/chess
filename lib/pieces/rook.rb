class Rook
    attr_accessor :incremental_moves, :ending_positions, :possible_positions, :color

    def initialize(color)
        @color = color
        @possible_positions = []
        @incremental_moves = [[0,1], [0,-1], [1,0], [-1,0]].freeze
        @ending_positions = [[0,1], [0,2], [0,3], [0,4], [0,5], [0,6], [0,7],
                 [0,-1], [0,-2], [0,-3], [0,-4], [0,-5], [0,-6], [0,-7],
                 [1,0], [2,0], [3,0], [4,0], [5,0],[6,0], [7,0],
                 [-1,0], [-2,0], [-3,0], [-4,0], [-5,0],[-6,0], [-7,0]].freeze
    end

    def to_s
        if @color == "black"
            "\u{2656}"
        elsif @color == "white"
            "\u{265C}"
        end
    end
end 
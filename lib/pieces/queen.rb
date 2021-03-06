class Queen
    attr_accessor :incremental_moves, :ending_positions, :possible_positions, :color
    
    def initialize(color)
        @color = color
        @possible_positions = []
        @incremental_moves = [[0,1], [0,-1], [1,0], [-1,0], [1,1], [1,-1], [-1,1], [-1,-1]].freeze
        @ending_positions = [[1,1], [2,2], [3,3], [4,4], [5,5], [6,6], [7,7],
                 [1,-1], [2,-2], [3,-3], [4,-4], [5,-5], [6,-6], [7,-7],
                 [-1,1], [-2,2], [-3,3], [-4,4], [-5,5], [-6,6], [-7,7],
                 [-1,-1], [-2,-2], [-3,-3], [-4,-4], [-5,-5], [-6,-6], [-7,-7],
                 [0,1], [0,2], [0,3], [0,4], [0,5], [0,6], [0,7],
                 [0,-1], [0,-2], [0,-3], [0,-4], [0,-5], [0,-6], [0,-7],
                 [1,0], [2,0], [3,0], [4,0], [5,0], [6,0], [7,0],
                 [-1,0], [-2,0], [-3,0], [-4,0], [-5,0], [-6,0], [-7,0]].freeze
    end

    def to_s
        if @color == "black"
            "\u{2655}"
        elsif @color == "white"
            "\u{265B}"
        end
    end
end 
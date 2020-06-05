class Bishop 
    attr_accessor :incremental_moves, :ending_positions, :possible_positions, :color
    
    def initialize(color)
        @color = color
        @possible_positions = []
        @incremental_moves = [[1,1], [1,-1], [-1,1], [-1,-1]].freeze
        @ending_positions = [[1,1], [2,2], [3,3], [4,4], [5,5], [6,6], [7,7],
                 [1,-1], [2,-2], [3,-3], [4,-4], [5,-5], [6,-6], [7,-7],
                 [-1,1], [-2,2], [-3,3], [-4,4], [-5,5], [-6,6], [-7,7],
                 [-1,-1], [-2,-2], [-3,-3], [-4,-4], [-5,-5], [-6,-6], [-7,-7]].freeze
    end

    def to_s
        if @color == "black"
            "\u{2657}"
        elsif @color == "white"
            "\u{265D}"
        end
    end
end 
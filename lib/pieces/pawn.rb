class Pawn 
    attr_accessor :incremental_moves, :ending_positions, :possible_positions, :color, :attack_moves

    def initialize(color)
        @color = color
        @possible_positions = []
        if @color == "black"
            @incremental_moves = [[0,-1]].freeze
            @ending_positions = [[0,-2], [0,-1]].freeze
            @attack_moves = [[-1,-1], [1,-1]].freeze
        elsif @color == "white"
            @incremental_moves = [[0,1]].freeze
            @ending_positions = [[0,2], [0,1]].freeze 
            @attack_moves = [[1,1], [-1,1]].freeze
        end
    end

    def to_s
        if @color == "black"
            "\u{2659}"
        elsif @color == "white"
            "\u{265F}"
        end
    end
end 
class Pawn
    attr_accessor :black, :white

    MOVES = [[2,0], [1,0], [1,1], [-1,1]].freeze
    
    def initialize
        @black = "\u{2659}"
        @white = "\u{265F}"
    end
end 
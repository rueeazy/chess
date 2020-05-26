class King
    attr_accessor :black, :white

    MOVES = [[0,1], [1,1], [1,0], [1,-1],
            [0,-1], [-1,-1], [-1,0], [-1,1]].freeze
    
    def initialize
        @black = "\u{2654}"
        @white = "\u{265A}"
    end
end 
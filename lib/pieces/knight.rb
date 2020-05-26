class Knight
    attr_accessor :black, :white

    MOVES = [[-2, 1], [-1, 2], [1, 2], [2, 1],
    [2, -1], [1, -2], [-1, -2], [-2, -1]].freeze
    
    def initialize
        @black = "\u{2658}"
        @white = "\u{265E}"
    end
end 
class Pawn
    attr_accessor :pawn

    MOVES = [[2,0], [1,0], [1,1], [-1,1]].freeze
    
    def initialize
        puts "\u{2659}"
    end
end
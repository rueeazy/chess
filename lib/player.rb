
class Player
    attr_reader :color, :choices

    BLACK_PIECES = ["\u{2657}", "\u{2654}", "\u{2658}", "\u{2659}", "\u{2655}", "\u{2656}"]
    WHITE_PIECES = ["\u{265D}", "\u{265A}", "\u{265E}", "\u{265F}", "\u{265B}", "\u{265C}"]
    
    def initialize(color)
        @color = color
    end

end
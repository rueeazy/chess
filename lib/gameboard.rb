Dir["./pieces/*.rb"].each {|file| require file }

class Gameboard 
    attr_accessor :board

    def initialize
        @board = Array.new(8) {Array.new(8,)}
    end

    def display_board
        puts "\n"
        puts "   -----------------------------------------------"
        puts "8 |  #{@board[0][7]}  |  #{@board[1][7]}  |  #{@board[2][7]}  |  #{@board[3][7]}  |  #{@board[4][7]}  |  #{@board[5][7]}  |  #{@board[6][7]}  |  #{@board[7][7]}  |"
        puts seperator = "   -----+-----+-----+-----+-----+-----+-----+-----"
        puts "7 |  #{@board[0][6]}  |  #{@board[1][6]}  |  #{@board[2][6]}  |  #{@board[3][6]}  |  #{@board[4][6]}  |  #{@board[5][6]}  |  #{@board[6][6]}  |  #{@board[7][6]}  |"
        puts seperator
        puts "6 |  #{@board[0][5]}  |  #{@board[1][5]}  |  #{@board[2][5]}  |  #{@board[3][5]}  |  #{@board[4][5]}  |  #{@board[5][5]}  |  #{@board[6][5]}  |  #{@board[7][5]}  |"
        puts seperator
        puts "5 |  #{@board[0][4]}  |  #{@board[1][4]}  |  #{@board[2][4]}  |  #{@board[3][4]}  |  #{@board[4][4]}  |  #{@board[5][4]}  |  #{@board[6][4]}  |  #{@board[7][4]}  |"
        puts seperator
        puts "4 |  #{@board[0][3]}  |  #{@board[1][3]}  |  #{@board[2][3]}  |  #{@board[3][3]}  |  #{@board[4][3]}  |  #{@board[5][3]}  |  #{@board[6][3]}  |  #{@board[7][3]}  |"
        puts seperator
        puts "3 |  #{@board[0][2]}  |  #{@board[1][2]}  |  #{@board[2][2]}  |  #{@board[3][2]}  |  #{@board[4][2]}  |  #{@board[5][2]}  |  #{@board[6][2]}  |  #{@board[7][2]}  |"
        puts seperator
        puts "2 |  #{@board[0][1]}  |  #{@board[1][1]}  |  #{@board[2][1]}  |  #{@board[3][1]}  |  #{@board[4][1]}  |  #{@board[5][1]}  |  #{@board[6][1]}  |  #{@board[7][1]}  |"
        puts seperator
        puts "1 |  #{@board[0][0]}  |  #{@board[1][0]}  |  #{@board[2][0]}  |  #{@board[3][0]}  |  #{@board[4][0]}  |  #{@board[5][0]}  |  #{@board[6][0]}  |  #{@board[7][0]}  |"
        puts "   -----------------------------------------------"
        puts "     A     B     C     D     E     F     G     H"
        puts "\n"
    end 

    def set_board(board = @board)
        white = "\u{25A0}"
        black = "\u{25A1}"
        board.each_with_index do |column, c|
            column.each_with_index do |cell, index|
                if c % 2 == 0
                    board[c][index] = black if index % 2 == 0 
                    if index % 2 != 0
                        board[c][index] = white 
                    end
                elsif c % 2 != 0
                    board[c][index] = white
                    if index % 2 != 0
                        board[c][index] = black
                    end
                end
            end
        end
    end

    def set_pieces(board = @board)
        #Rook Setup
        board[0][7] = Rook.new("black") && board[7][7] = Rook.new("black")
        board[0][0] = Rook.new("white") && board[7][0] = Rook.new("white")
        #Knight Setup
        board[1][7] = Knight.new("black") && board[6][7] = Knight.new("black")
        board[1][0] = Knight.new("white") && board[6][0] = Knight.new("white")
        #Bishop Setup
        board[2][7] = Bishop.new("black") && board[5][7] = Bishop.new("black")
        board[2][0] = Bishop.new("white") && board[5][0] = Bishop.new("white")
        #Queen Setup
        board[3][7] = Queen.new("black")
        board[3][0] = Queen.new("white")
        #King Setup
        board[4][7] = King.new("black")
        board[4][0] = King.new("white")
        #Pawn Setup
        board.each_with_index do |column, c|
            column.each_with_index do |cell, index|
                if index == 6
                    board[c][index] = Pawn.new("black")
                elsif index == 1
                    board[c][index] = Pawn.new("white")
                end 
            end
        end
    end

end

# board = Gameboard.new
# board.set_board
# board.set_pieces
# board.display_board


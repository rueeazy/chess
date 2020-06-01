require_relative 'gameboard.rb'
require_relative 'cell.rb'
Dir["./pieces/*.rb"].each {|file| require file }

require 'pry'

class Game
    attr_accessor :board, :player, :start, :destination

    BLACK_PIECES = ["\u{2657}", "\u{2654}", "\u{2658}", "\u{2659}", "\u{2655}", "\u{2656}"]
    WHITE_PIECES = ["\u{265D}", "\u{265A}", "\u{265E}", "\u{265F}", "\u{265B}", "\u{265C}"]
    
    def initialize
        @player = "White"
        @board = Gameboard.new
        @dummyboard = Gameboard.new
        @gameboard = @board.board
        puts "                Welcome to Chess!"
        print "       Are you ready to play?"
        puts "   [1] Yes   [2] No"
        response = gets.chomp.to_i
        if response == 1
            set_board
            game_play
        else exit!
        end
    end

    def set_board
        @board.set_board
        @board.set_pieces
        @board.display_board
    end

    def game_play
        @start = []
        @destination = []
        50.times do
        reset_move
        select_move
        piece_moves
        puts "          Last move was #{@start.join("")} -> #{@destination.join("")}."
        @board.display_board
        switch_player
        end
    end

    def piece_moves
        build_tree
        @target_cell = @dummyboard.board[@destination_coor[0]][@destination_coor[1]]
        if !@target_cell.instance_of? Cell
            puts "Not a valid move."
        elsif path_clear?
            @gameboard[@destination_coor[0]][@destination_coor[1]] = @selected_piece
        else puts "Path is blocked"
        end
        reset_piece
        reset_board_space(@start_coor)
    end

    #builds tree of possible moves for @selected_piece
    def build_tree
        @start_coor = convert_input_to_coor(@start)
        @destination_coor = convert_input_to_coor(@destination)
        @selected_piece = @gameboard[@start_coor[0]][@start_coor[1]]
        starting_cell = Cell.new(@start_coor[0], @start_coor[1])
        possible_positions = find_possible_positions_from_origin([starting_cell.x, starting_cell.y])
        queue = []
        queue.unshift(starting_cell)
        until queue.empty?
            current = queue.shift
             if possible_positions.include?(@destination_coor)
                @selected_piece.possible_positions = find_possible_incremental_moves(([current.x, current.y]))

                @selected_piece.possible_positions.each do |move|
                    next unless !@dummyboard.board[move[0]][move[1]].instance_of? Cell

                    linked_cell = Cell.new(move[0], move[1])
                    current.edges << linked_cell
                    linked_cell.path = current.path + linked_cell.path
                    @dummyboard.board[move[0]][move[1]] = linked_cell
                    queue.push(linked_cell)
                end
            end
        end
    end

    #returns possible moves for @selected_piece
    def find_possible_positions_from_origin(pos)
            moves = @selected_piece.ending_positions.collect {|item| [pos[0] + item[0], pos[1] + item[1]]}
            moves = moves.select! {|item| valid_move?(item)}
            moves     
    end

    def find_possible_incremental_moves(pos)
            moves = @selected_piece.incremental_moves.collect {|item| [pos[0] + item[0], pos[1] + item[1]]}
            moves.select! {|item| valid_move?(item)}
            moves
    end

    #filters off of board moves out
    def valid_move?(pos)
        (0..7).include?(pos[0]) && (0..7).include?(pos[1]) ? true : false
    end
    
    #resets start and end coordinate for each players turn
    def reset_move
        @start = []
        @destination = []
    end

    #asks player for start and end coordinates
    def select_move
        puts "It's #{player}'s turn. Please enter your move/command."
        input = gets.chomp.split("")
        @start.push(input[0]) && @start.push(input[1])
        @destination.push(input[3]) && @destination.push(input[4])
    end

    #converts player inputs to coordinates on board
    def convert_input_to_coor(array)
        letters = ["a", "b", "c", "d", "e", "f", "g", "h"]
        num1 = letters.index(array[0])
        num2 = array[1].to_i
        coordinate = [num1, num2 - 1]
    end

    #switches player turn
    def switch_player
        player == "Black" ? @player = "White" : @player = "Black"
    end

    #clears start board space after move
    def reset_board_space(start_coor)
        @dummyboard.set_board
        @gameboard[start_coor[0]][start_coor[1]] = @dummyboard.board[start_coor[0]][start_coor[1]]
    end

    #clears possible positions array after each piece move
    def reset_piece
        @selected_piece.possible_positions = []
    end

    #verifies path from start to distance is clear
    def path_clear?
        i = 0
        @target_path = @target_cell.path[1...@target_cell.path.length - 1]
        @target_path.each do |coor|
            i += 1 if @gameboard[coor[0]][coor[1]] != "\u{25A0}" && @gameboard[coor[0]][coor[1]] != "\u{25A1}"
        end
        i == 0 ? true : false
    end

end

game = Game.new

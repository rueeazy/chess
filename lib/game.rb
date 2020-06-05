require_relative 'gameboard.rb'
require_relative 'cell.rb'
require_relative 'player.rb'
Dir["./pieces/*.rb"].each {|file| require file }

require 'yaml'

class Game
    attr_accessor :board, :player, :start, :destination

    def initialize
        @white = Player.new("white")
        @black = Player.new("black")
        @player = @white
        @board = Gameboard.new
        @dummyboard = Gameboard.new
        @gameboard = @board.board
        introduction
    end

    def set_board
        @board.set_board
        @board.set_pieces
    end

    def game_play
        @check = false
        @board.display_board
        @start = []
        @destination = []
        until victory?
        reset_move
        select_move
        until valid_move?
            reset_move
            reset_piece
            reset_dummy_board
            select_move
        end
        place_piece
        log_move
        @board.display_board
        if @check == true
            check?
            game_end_checkmate if reverse_mate?
            game_play
        end
        check?
        switch_player
        end
        game_end
    end

    #checks if selected_move is a playable move.
    def valid_move?
        reset_dummy_board
        return false if !picked_appropriate_piece?
        build_tree
        @target_cell = @dummyboard.board[@destination_coor[0]][@destination_coor[1]]
        if !@target_cell.instance_of? Cell
            puts "Not a valid move."
            puts "\n"
            return false
        elsif @selected_destination.class != String && @selected_destination.color == @player.color
            puts "FRIENDLY FIRE. SELECT ANOTHER MOVE."
            puts "\n"
            return false
        elsif !path_clear?
            puts "Path is blocked."
            puts "\n"
            return false
        else return true
        end   
    end

    #places_piece on board if playable move
    def place_piece
        if !@selected_destination.instance_of? String
            puts "You have siezed a #{@selected_destination.class}."
            @gameboard[@destination_coor[0]][@destination_coor[1]] = @selected_piece
        else
            @gameboard[@destination_coor[0]][@destination_coor[1]] = @selected_piece
        end
        promote if pawn_promotable?
        reset_piece
        reset_board_space(@start_coor)
    end

    #builds tree of possible moves for @selected_piece
    def build_tree
        starting_cell = Cell.new(@start_coor[0], @start_coor[1])
        if @selected_piece.instance_of? Pawn
            possible_positions = pawn_possible_positions(starting_cell)
        else possible_positions = find_possible_positions_from_origin([starting_cell.x, starting_cell.y])
        end
        queue = []
        queue.unshift(starting_cell)
        until queue.empty?
            current = queue.shift
             if possible_positions.include?(@destination_coor)
                if @selected_piece.instance_of? Pawn
                    @selected_piece.possible_positions = possible_positions
                else
                    @selected_piece.possible_positions = find_possible_incremental_moves(([current.x, current.y]))
                end

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

    #finds pawns possible moves since they can vary
    def pawn_possible_positions(starting_cell)
        if @start_coor[1] == 1 && @selected_piece.color == "white" && @selected_destination.class == String
            possible_positions = find_possible_positions_from_origin([starting_cell.x, starting_cell.y])
        elsif @start_coor[1] == 1 && @selected_piece.color == "white" && @selected_destination.class != String
            possible_positions = pawn_possible_attack_moves([starting_cell.x, starting_cell.y])
        elsif @start_coor[1] != 1 && @selected_piece.color == "white" && @selected_destination.class == String
            possible_positions = find_possible_incremental_moves([starting_cell.x, starting_cell.y])
        elsif @start_coor[1] != 1 && @selected_piece.color == "white" && @selected_destination.class != String
            possible_positions = pawn_possible_attack_moves([starting_cell.x, starting_cell.y])
        elsif @start_coor[1] == 6 && @selected_piece.color == "black" && @selected_destination.class == String
            possible_positions = find_possible_positions_from_origin([starting_cell.x, starting_cell.y])
        elsif @start_coor[1] == 6 && @selected_piece.color == "black" && @selected_destination.class != String
            possible_positions = pawn_possible_attack_moves([starting_cell.x, starting_cell.y])
        elsif @start_coor[1] != 6 && @selected_piece.color == "black" && @selected_destination.class == String
            possible_positions = find_possible_incremental_moves([starting_cell.x, starting_cell.y])
        elsif @start_coor[1] != 6 && @selected_piece.color == "black" && @selected_destination.class != String
            possible_positions = pawn_possible_attack_moves([starting_cell.x, starting_cell.y])
        else puts "Not a valid move."
             puts "\n"
             reset_move
             select_move
             piece_moves
        end
        possible_positions
    end

    #returns possible moves for @selected_piece
    def find_possible_positions_from_origin(pos)
        moves = @selected_piece.ending_positions.collect {|item| [pos[0] + item[0], pos[1] + item[1]]}
        moves.select! {|item| possible_move?(item)}
        moves     
    end

    #returns possible step by step moves to check path
    def find_possible_incremental_moves(pos)
        moves = @selected_piece.incremental_moves.collect {|item| [pos[0] + item[0], pos[1] + item[1]]}
        moves.select! {|item| possible_move?(item)}
        moves
    end

    #returns possible attack moves for pawn
    def pawn_possible_attack_moves(pos)
        moves = @selected_piece.attack_moves.collect {|item| [pos[0] + item[0], pos[1] + item[1]]}
        moves.select! {|item| possible_move?(item)}
        moves
    end

    #filters out if board moves out
    def possible_move?(pos)
        (0..7).include?(pos[0]) && (0..7).include?(pos[1]) ? true : false
    end
    
    #resets start and end coordinate for each players turn
    def reset_move
        @start = []
        @destination = []
    end

    #asks player for start and end coordinates
    def select_move
        puts "It's #{@player.color}'s turn. Please enter your move/command."
        input = gets.chomp.downcase.split("")
        check_move_input(input)
    end

    #checks if the selected move has a valid input
    def check_move_input(input)
        letters = ("a".."h")
        numbers = (1..8)
        if input.join("") == "save"
            save_game
        elsif input.join("") == "exit"
            introduction
        elsif !letters.include?(input[0] && input[3]) && !numbers.include?(input[1] && input[4])
            puts malformed_input_message(input)
            select_move
        elsif input.length > 5
            puts malformed_input_message(input)
            select_move
        else
            @start.push(input[0]) && @start.push(input[1])
            @destination.push(input[3]) && @destination.push(input[4])
            @start_coor = convert_input_to_coor(@start)
            @destination_coor = convert_input_to_coor(@destination)
            @selected_piece = @gameboard[@start_coor[0]][@start_coor[1]]
            @selected_destination = @gameboard[@destination_coor[0]][@destination_coor[1]]
        end
    end

    #checks if player selects their color piece
    def picked_appropriate_piece?
        if @selected_piece.class != String && @selected_piece.color == @player.color
            return true
        else return false
        end
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
        @player.color == "black" ? @player = @white : @player = @black
    end

    #clears start board space after move
    def reset_board_space(start_coor)
        @dummyboard.set_board
        @gameboard[start_coor[0]][start_coor[1]] = @dummyboard.board[start_coor[0]][start_coor[1]]
    end

    #resets dummy board
    def reset_dummy_board
        @dummyboard.set_board
    end

    #clears possible positions array after each piece move
    def reset_piece
        @selected_piece.possible_positions = [] if !@selected_piece.instance_of? String
    end

    #verifies path from start to distance is clear
    def path_clear?
        i = 0
        if @target_cell.path.length < 2 
            @target_path = @target_cell.path
        else
            @target_path = @target_cell.path[1...@target_cell.path.length - 1]
        end
        @target_path.each do |coor|
            i += 1 if @gameboard[coor[0]][coor[1]] != "\u{25A0}" && @gameboard[coor[0]][coor[1]] != "\u{25A1}"
        end
        i == 0 ? true : false
    end

    #checks if space is clear
    def occupied?
        if @selected_destination.class == String
            return false
        else return true
        end 
    end

    #checks if pawn can upgrade at the end of the board
    def pawn_promotable?
        if @selected_piece.class != Pawn
            return false
        elsif @selected_piece.class == Pawn
            if @destination_coor[1] == 0 || @destination_coor[1] == 7
                return true
            end
        end
    end

    #promote pawn to upgraded piece
    def promote
        puts "Your pawn made it across the board in one piece!"
        puts "That means you're eligible to upgrade it to another piece"
        puts "Select which piece you would like to upgrade it to."
        puts "[1] Queen     [2] Bishop     [3] Rook     [4] Knight"
        promotions = {
            1 => Queen.new("#{@player.color}"),
            2 => Bishop.new("#{@player.color}"),
            3 => Rook.new("#{@player.color}"),
            4 => Knight.new("#{@player.color}")
        }
        input = gets.chomp.to_i
        if !(1..4).include?(input)
            promote
        else
        @gameboard[@destination_coor[0]][@destination_coor[1]] = promotions[input]
        end
    end

    #checks for check
    def check?
        @start_coor = @destination_coor
        @gameboard.each_with_index do |column, c|
            column.each_with_index do |cell, index|
                if @gameboard[c][index].class == King && @gameboard[c][index].color != @player.color
                    @destination_coor = [c, index]
                end
            end
        end
        build_tree
        @target_cell = @dummyboard.board[@destination_coor[0]][@destination_coor[1]]
        if @target_cell.class == Cell && path_clear?
            if mate?
                puts "CHECKMATE!"
                @check = true
                return true
            else 
                puts "CHECK!"
                @check = true
                return true
            end
        end
        false
    end

    #checks if check is also mate a.k.a. if the king can move out of danger
    def mate?
        king_possible_escapes = find_possible_incremental_moves(@destination_coor)
        king_possible_escapes.select! {|pos| surrounding_space_clear?(pos)}
        king_possible_escapes.each do |space|
            @gameboard.each_with_index do |column, c|
                column.each_with_index do |cell, index|
                    if @gameboard[c][index].class != String && @gameboard[c][index].color == @player.color
                        @start_coor = [c, index]
                        @destination_coor = [space[0], space[1]]
                        build_tree
                        @target_cell = @dummyboard.board[@destination_coor[0]][@destination_coor[1]]
                        if @target_cell.class == Cell && path_clear?
                            king_possible_escapes.delete(space)
                        end
                    end
                end
            end
        end
        return true if king_possible_escapes.empty?
    end

    #checks if player who just got checked, moved their king out of check
    def reverse_mate?
        @gameboard.each_with_index do |column, c|
            column.each_with_index do |cell, index|
                if @gameboard[c][index].class == King && @gameboard[c][index].color == @player.color
                    @destination_coor = [c, index]
                end
            end
        end
        king_possible_escapes = find_possible_incremental_moves(@destination_coor)
        king_possible_escapes.select! {|pos| surrounding_space_clear?(pos)}
        king_possible_escapes.each do |space|
            @gameboard.each_with_index do |column, c|
                column.each_with_index do |cell, index|
                    if @gameboard[c][index].class != String && @gameboard[c][index].color != @player.color
                        @start_coor = [c, index]
                        @destination_coor = [space[0], space[1]]
                        build_tree
                        @target_cell = @dummyboard.board[@destination_coor[0]][@destination_coor[1]]
                        if @target_cell.class == Cell && path_clear?
                            king_possible_escapes.delete(space)
                        end
                    end
                end
            end
        end
        return true if king_possible_escapes.empty?
    end

    #checks if space is clear for king escape
    def surrounding_space_clear?(pos)
        @gameboard[pos[0]][pos[1]].class == String ? true : false
    end
    
    #checks if one king is taken off board signifying game over
    def victory?
        kings = 0
        @gameboard.each_with_index do |column, c|
            column.each_with_index do |cell, index|
                if @gameboard[c][index].class == King
                    kings += 1
                end
            end
        end
        return true if kings < 2
        false 
    end

    #saves game
    def save_game
        print "Name Your Game (no spaces): "
        id = gets.chomp
        if id.split("").include?(" ")
            puts "Sorry, please name your game with no spaces."
            save_game
        end
        if Dir.entries("saved_games").include?("#{id}.yaml")
            puts "That name is already taken, would you like to overwrite?"
            puts "   [1] Yes   [2] No"
            input = gets.chomp.to_i
            if input == 2
                save_game
            elsif input == 1
                print "Saving..."
                filename = "saved_games/#{id}.yaml" 
                File.open("#{filename}", "w") {|file| file.write save_to_yaml}
                sleep(0.6)
                print "Saved!\n"
                sleep(0.6)
            else save_game
            end
        else
        print "Saving ... " 
        Dir.mkdir("saved_games") unless Dir.exists? "saved_games"
        filename = "saved_games/#{id}.yaml"
        File.open("#{filename}", "w") {|file| file.write save_to_yaml}
        sleep(0.6)
        print "Saved!\n"
        sleep(0.6)
        end
    end

    #creates YAML file
    def save_to_yaml
        game_data = {
            player: @player,
            white: @white,
            black: @black,
            board: @board,
            dummyboard: @dummyboard,
            gameboard: @gameboard
    }
    YAML.dump(game_data)
    end

    #loads saved game
    def load_game
        puts "\n Select a saved game below"
        display_saved_games
        puts "\n"
        filename = gets.chomp
        if !Dir.entries("saved_games").include?("#{filename}.yaml")
            puts "\n #{filename} does not exist."
            load_game
        end
        file = YAML.load_file("saved_games/#{filename}.yaml")
        #load data and start game
        @player = file[:player]
        @white = file[:white]
        @black = file[:black]
        @board = file[:board]
        @dummyboard = file[:dummyboard]
        @gameboard = file[:gameboard]

        game_play
    end

    #displays saved games
    def display_saved_games
        files = Dir.entries("saved_games")
        files.each do |file|
            next if file == "." || file == ".."
            puts File.basename(file, ".yaml")
        end
    end

    #game ends
    def game_end
        switch_player
        puts "#{@player.color} siezed the opposing king, game over!"
        exit!
    end

    def game_end_checkmate
        puts "#{@player.color} didn't move their king out of check. They lose!"
        exit!
    end

    #MESSAGES

    def introduction
        puts " \n"
        print "     Welcome to chess! "
        puts "What would you like to do?"
        puts "
        
      * Start a new Game  ->  Enter 'new'
      * Load a saved Game ->  Enter 'load'

      * Exit              ->  Enter 'exit'"
      input = gets.chomp.downcase
      if input == "new"
        instructions
      elsif input == "load"
        load_game
      elsif input == "exit"
        exit!
      else 
        introduction
      end
    end
    
    def instructions
        puts "
                        Welcome to Chess!

    The Game is played between two players that each take control
    of one set of colored pieces (White and Black).
    The goal of the game is to capture the opponents King.
    If a player cannot prevent the capture of his King in the next turn, he
    or she is declared checkmate and the game ends.

    White always starts (the color on the bottom of the screen, it might look
    like another color on your screen) and every player can move one piece
    per turn. For further rules of how to play the game you better google a bit.

    To tell the game which piece you want to move where, you have to enter the
    start and end coordinates (in lowercase letters) like so -> 'e2:e4'.
    You can save the game at any point by entering 'save' or exit it
    by entering 'exit'.\n
    Now, have Fun!
    "
    print "       Are you ready to play?"
    puts "   [1] Yes   [2] No"
    response = gets.chomp.to_i
        if response == 1
            set_board
            game_play
        elsif response == 2 
            exit!
        else 
            instructions
        end
    end

    def log_move
        puts "          Last move was #{@start.join("")} -> #{@destination.join("")}."
    end

    def malformed_input_message(input)
        "
        '#{input.join("")}' couldn't be interpreted.
        You can enter one of the following keywords:
          'save'    to save the game
          'exit'    to return to the start screen
        A move can be entered by specifying the coordinates of the
        start- and end-square like so: 'c3:e5'.
    "
    end

end
game = Game.new
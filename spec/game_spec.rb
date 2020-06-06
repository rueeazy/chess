require './lib/game.rb'
require './lib/gameboard.rb'
Dir["./lib/pieces/*.rb"].each {|file| require file }

require 'stringio'

describe Game do
    let(:game) { Game.new }
    before(:each) do
        @board = Gameboard.new
        @gameboard = @board.board
        @dummyboard = Gameboard.new
    end

    it "creates a board once initialized" do
        expect(@board).to be_an_instance_of(Gameboard)
        expect(@gameboard.size).to eq(8)
    end
end

require './lib/game.rb'
Dir["./lib/pieces/*.rb"].each {|file| require file }

game = Game.new
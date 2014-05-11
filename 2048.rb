#!/usr/bin/env ruby
require 'pp'
require 'stringio'
require './board.rb'

games = 0
max_tiles = []

begin
	b = Board.new

	def move
		return REVERSED_MOVES[rand(4)]
	end

	loop do
		# puts b
		if b.game_over?
			puts b
			games += 1
			raise GameOver
		end

		# print "? "
		b.move move
	end

rescue GameOver
	puts "Game over man, game over!"
	puts "Your score was: #{b.score}"
	puts "The maximum tile was: #{b.highest_tile}"
	max_tiles << b.highest_tile
	puts "Total games: #{games}"
	puts "Max tile so far: #{max_tiles.max}"
	if b.score > 10000
		gets.chomp
	end
	puts
	puts
	retry
end
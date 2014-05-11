class GameOver < StandardError; end

MOVES = {
	"w" => 3,
	"s" => 1,
	"a" => 0,
	"d" => 2
}

REVERSED_MOVES = MOVES.invert

class Board
	attr_accessor :board, :size, :score

	MOVES = {
		'w' => 3,
		's' => 1,
		'a' => 0,
		'd' => 2
	}
	SEEDS = [2,4]

	def initialize(size=4)
		@board = Array.new(size) { Array.new(size,0) }
		@size = size
		@score = 0

		spawn_new
		spawn_new
	end

	def rotate!(n=1)
		@board = (0..@size-1).map {|i| @board.map{|row| row[i] }.reverse }
	end

	# Slide the puzzle lefts
	# To slide other directions,
	def slide
		moves = 0

	# Collapse zeroes
	(0...@size).each do|row|
		(0...@size-1).each do|col|
			while @board[row][col] == 0 && @board[row][col+1..@size-1].max > 0
				@board[row][col...@size-1] = @board[row][col+1..@size-1] + [0]
				moves += 1
			end
		end
	end

	# Collapse like cells
	(0...@size).each do|row|
		(0...@size-1).each do|col|
			if @board[row][col] != 0 && @board[row][col] == @board[row][col+1]
				@board[row][col..@size-1] = @board[row][col+1..@size-1] + [0]
				@board[row][col] *= 2
				@score += @board[row][col]
				moves += 1
			end
		end
	end

	return moves
end

def game_over?
	if @board.flatten.include?(0)
		return false
	end

	game_over = true
	4.times do
		@board.each do|row|
			row.each_cons(2) do|nums|
				game_over = false if nums.first == nums.last
			end
		end

		rotate!
	end

	return game_over
end


def move(char)
	m = MOVES[char]
	return 0 if m.nil?

	m.times { rotate! }
	moves = slide
	(4-m).times { rotate! }

	spawn_new if moves != 0
	return moves
end


# Spawning
def empty_cells
	@board.map.with_index do|row, rowidx|
		row.map.with_index do|num, colidx|
			[rowidx, colidx, num]
		end
	end.flatten(1).find_all{|cell| cell[2] == 0}
end

def spawn_new
	empty = empty_cells

	cell = empty.sample(1).flatten
	@board[cell[0]][cell[1]] = SEEDS.sample(1).first
end


# Display
def format_border(cell_size)
	"+" + (['-' * cell_size] * @board.size).join('+') + "+"
end

def format_row(cell_size, row)
	row_strings = @board[row].map do|cell|
		if cell == 0
			" " * cell_size
		else
			padding_left = (cell_size - cell.to_s.length) / 2
			padding_right = cell_size - padding_left - cell.to_s.length

			(" " * padding_left) + cell.to_s + (" " * padding_right)
		end
	end

	"|" + row_strings.join('|') + "|"
end

def to_s
	cell_size = @board.flatten.max.to_s.length + 2
	str = StringIO.new
	str.puts "Score: #{@score}"

	str.puts format_border(cell_size)

	(0...@size).each do|row|
		str.puts format_row(cell_size, row)
		str.puts format_border(cell_size)
	end

	str.string
end

def highest_tile
	@board.flatten.max
end

end
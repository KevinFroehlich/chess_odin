class GameBoard
  attr_accessor :board

  def initialize
    @board = fill_board
  end

  def fill_board
    board = {}
    (3..6).each do |row|
      (1..8).each do |column|
        board["#{column}#{row}"] = nil
        board["#{column}2"] = Piece.new('pawn', 'white')
        board["#{column}7"] = Piece.new('pawn', 'black')
      end
    end
    (1..8).each do |column|
      board["#{column}2"] = Piece.new('pawn', 'white')
      board["#{column}7"] = Piece.new('pawn', 'black')
    end

    [1, 8].each do |row|
      (1..8).each do |column|
        board["#{column}#{row}"] = Piece.new('rook', 'white') if [1, 8].include?(column) && row == 1
        board["#{column}#{row}"] = Piece.new('rook', 'black') if [1, 8].include?(column) && row == 8
        board["#{column}#{row}"] = Piece.new('knight', 'white') if [2, 7].include?(column) && row == 1
        board["#{column}#{row}"] = Piece.new('knight', 'black') if [2, 7].include?(column) && row == 8
        board["#{column}#{row}"] = Piece.new('bishop', 'white') if [3, 6].include?(column) && row == 1
        board["#{column}#{row}"] = Piece.new('bishop', 'black') if [3, 6].include?(column) && row == 8
        board["#{column}#{row}"] = Piece.new('queen', 'white') if (column == 4) && row == 1
        board["#{column}#{row}"] = Piece.new('queen', 'black') if (column == 4) && row == 8
        board["#{column}#{row}"] = Piece.new('king', 'white') if (column == 5) && row == 1
        board["#{column}#{row}"] = Piece.new('king', 'black') if (column == 5) && row == 8
      end
    end
    board
  end

  def print_board
    print_board = []
    (1..8).each do |row|
      (1..8).each do |column|
        if @board["#{column}#{row}"].nil?
          print_board << ' '
        elsif @board["#{column}#{row}"].kind == 'pawn' && @board["#{column}#{row}"].color == 'white'
          print_board << '♙'
        elsif @board["#{column}#{row}"].kind == 'rook' && @board["#{column}#{row}"].color == 'white'
          print_board << '♖'
        elsif @board["#{column}#{row}"].kind == 'bishop' && @board["#{column}#{row}"].color == 'white'
          print_board << '♗'
        elsif @board["#{column}#{row}"].kind == 'knight' && @board["#{column}#{row}"].color == 'white'
          print_board << '♘'
        elsif @board["#{column}#{row}"].kind == 'king' && @board["#{column}#{row}"].color == 'white'
          print_board << '♔'
        elsif @board["#{column}#{row}"].kind == 'queen' && @board["#{column}#{row}"].color == 'white'
          print_board << '♕'
        elsif @board["#{column}#{row}"].kind == 'pawn' && @board["#{column}#{row}"].color == 'black'
          print_board << '♟'
        elsif @board["#{column}#{row}"].kind == 'rook' && @board["#{column}#{row}"].color == 'black'
          print_board << '♜'
        elsif @board["#{column}#{row}"].kind == 'bishop' && @board["#{column}#{row}"].color == 'black'
          print_board << '♝'
        elsif @board["#{column}#{row}"].kind == 'knight' && @board["#{column}#{row}"].color == 'black'
          print_board << '♞'
        elsif @board["#{column}#{row}"].kind == 'king' && @board["#{column}#{row}"].color == 'black'
          print_board << '♚'
        elsif @board["#{column}#{row}"].kind == 'queen' && @board["#{column}#{row}"].color == 'black'
          print_board << '♛'
        end
      end
    end

    row_arr = []
    8.times do |index|
      print_row = "#{index + 1} |"
      8.times do
        print_row << print_board.shift + '|'
      end
      row_arr << print_row
    end
    puts '   a b c d e f g h'
    row_arr.reverse.each do |sentence|
      puts sentence
    end
  end
end

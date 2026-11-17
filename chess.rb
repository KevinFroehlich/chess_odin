require_relative 'rook_methods'
require_relative 'knight_methods'
require_relative 'bishop_methods'
require_relative 'king_methods'
require_relative 'queen_methods'
require_relative 'pawn_methods'
require 'yaml'

class Piece
  attr_accessor :kind, :color

  def initialize(kind, color)
    @kind = kind
    @color = color
  end
end

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

class Player
  attr_accessor :color

  def initialize(color)
    @color = color
  end
end

class GameController
  attr_accessor :p1, :p2, :board, :active_player

  def initialize
    @p1 = Player.new('white')
    @p2 = Player.new('black')
    @board = GameBoard.new
    @active_player = @p1
  end

  def alternate_player
    @active_player = if @active_player == @p1
                       @p2
                     else
                       @p1
                     end
    puts "Player #{@active_player.color.capitalize}'s turn."
  end

  def game_loop
    puts 'Player White starts!'
    puts "Enter 'save' to save or 'load' to load, 'exit' for exit."
    loop do
      @board.print_board
      make_move
      if check_winner?
        puts "Player #{@active_player.color.capitalize} wins the game via check-mate. Congrats!"
        break
      end
      alternate_player
    end
  end

  def ai_game_loop
    puts 'Player White starts!'
    puts "Enter 'save' to save or 'load' to load, 'exit' for exit."
    loop do
      @board.print_board
      make_move
      if check_winner?
        puts "Player #{@active_player.color.capitalize} wins the game via check-mate. Congrats!"
        break
      end
      alternate_player
      ai_move
      if check_winner?
        puts "Player #{@active_player.color.capitalize} wins the game via check-mate. Congrats!"
        break
      end
      alternate_player
    end
  end

  def get_piece_position
    loop do
      print 'Choose one of your pieces. Enter a1, b1 etc.'
      piece_position = gets.downcase.chomp
      if piece_position == 'save'
        save_game
        next
      elsif piece_position == 'load'
        load_game
        @board.print_board
        next
      elsif piece_position == 'exit'
        exit
      end
      piece_position = piece_position.split('')
      piece_position[0] = (piece_position[0].ord - 96).to_s
      piece_position = piece_position.join('')

      if !@board.board[piece_position].nil? && @board.board[piece_position].color == @active_player.color
        return piece_position.split('').map(&:to_i)
      end

      puts 'Incorrect input, please choose one of your pieces to move.'
    end
  end

  def get_target_position
    loop do
      print 'Choose a tile to move towards. Enter a1, b1 etc.'
      target_position = gets.downcase.chomp
      if target_position == 'save'
        save_game
        next
      elsif target_position == 'load'
        load_game
        next
      elsif target_position == 'exit'
        exit
      end
      target_position = target_position.split('')
      p target_position[0] = (target_position[0].ord - 96).to_s
      target_position = target_position.join('')

      unless !@board.board.keys.include?(target_position) || !@board.board[target_position].nil? && @board.board[target_position].color == @active_player.color
        return target_position.split('').map(&:to_i)
      end

      puts 'Incorrect input, please choose an empty tile or a tile occupied by an opposing piece as your destination.'
    end
  end

  def check_winner?
    if @active_player.color == 'white'
      @board.board.values.compact.none? do |piece|
        piece.kind == 'king' && piece.color == 'black'
      end
    else
      @board.board.values.compact.none? do |piece|
        piece.kind == 'king' && piece.color == 'white'
      end
    end
  end

  def get_enemy_king_coordinates
    enemy_king = if @active_player.color == 'white'
                   @board.board.values.compact.find { |piece| piece.kind == 'king' && piece.color == 'black' }
                 else
                   @board.board.values.compact.find { |piece| piece.kind == 'king' && piece.color == 'white' }
                 end

    @board.board.key(enemy_king).split('').map { |coordinate| coordinate.to_i }
  end

  def make_move
    loop do
      piece_position = get_piece_position
      target_position = get_target_position
      kind = @board.board["#{piece_position[0]}#{piece_position[1]}"].kind

      if valid_move?(piece_position, target_position, kind)
        puts "Player #{@active_player.color.capitalize} says check." if valid_move?(target_position,
                                                                                    get_enemy_king_coordinates, kind)
        @board.board["#{target_position[0]}#{target_position[1]}"] =
          @board.board["#{piece_position[0]}#{piece_position[1]}"]
        @board.board["#{piece_position[0]}#{piece_position[1]}"] = nil
        break
      else
        puts 'Invalid move detected. Please enter a valid move.'
      end
    end
  end

  def ai_move
    loop do
      piece_position = [rand(1..8), rand(1..8)]
      if @board.board["#{piece_position[0]}#{piece_position[1]}"].nil? || @board.board["#{piece_position[0]}#{piece_position[1]}"].color != @active_player.color
        next
      end

      target_position = [rand(1..8), rand(1..8)]
      kind = @board.board["#{piece_position[0]}#{piece_position[1]}"].kind

      next unless valid_move?(piece_position, target_position, kind)

      puts "Player #{@active_player.color.capitalize} says check." if valid_move?(target_position,
                                                                                  get_enemy_king_coordinates, kind)
      @board.board["#{target_position[0]}#{target_position[1]}"] =
        @board.board["#{piece_position[0]}#{piece_position[1]}"]
      @board.board["#{piece_position[0]}#{piece_position[1]}"] = nil
      break
    end
  end

  def valid_move?(piece_position, target_position, kind)
    case kind
    when 'pawn'
      if valid_pawn_move?(piece_position, target_position)
        trans_pawn(piece_position) if pawn_trans?(target_position)
        true
      else
        false
      end
    when 'rook'
      valid_rook_move?(piece_position, target_position)
    when 'knight'
      valid_knight_move?(piece_position, target_position)
    when 'bishop'
      valid_bishop_move?(piece_position, target_position)
    when 'queen'
      valid_queen_move?(piece_position, target_position)
    when 'king'
      valid_king_move?(piece_position, target_position)
    end
  end

  def save_game
    File.write('save.yaml', YAML.dump(self))
    puts 'Game saved.'
  end

  def load_game
    game = YAML.unsafe_load_file('save.yaml')
    @active_player = game.active_player
    @board = game.board
    @p1 = game.p1
    @p2 = game.p2
    puts 'Game loaded'
    puts "Player #{@active_player.color}'s turn."
  end
end

game = GameController.new
game.ai_game_loop

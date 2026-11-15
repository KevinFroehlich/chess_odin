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
  end

  def get_piece_position
    loop do
      piece_position = gets.downcase.chomp.split('')
      piece_position[0] = (piece_position[0].ord - (piece_position[0].ord - 1)).to_s
      piece_position = piece_position.join('')

      if !@board.board[piece_position].nil? && @board.board[piece_position].color == @active_player.color
        return piece_position.split('').map(&:to_i)
      end

      puts 'Incorrect input, please choose one of your pieces to move.'
    end
  end

  def get_target_position
    loop do
      target_position = gets.downcase.chomp.split('')
      target_position[0] = (target_position[0].ord - (target_position[0].ord - 1)).to_s
      target_position = target_position.join('')

      unless !@board.board.keys.include?(target_position) || !@board.board[target_position].nil? && @board.board[target_position].color == @active_player.color
        return target_position.split('').map(&:to_i)
      end

      puts 'Incorrect input, please choose an empty tile or a tile occupied by an opposing piece as your destination.'
    end
  end

  def valid_pawn_move?(piece_position, target_position)
    if @active_player.color == 'white'
      attack_moves = [[1, 1], [- 1, 1]]
      valid_moves = attack_moves.map do |column, row|
        [column + piece_position[0], row + piece_position[1]]
      end
                                .select do |column, row|
                                  column.between?(1,
                                                  8) && row.between?(1,
                                                                     8) && !@board.board["#{column}#{row}"].nil? && @board.board["#{column}#{row}"].color != @active_player.color
                                end
      if @board.board["#{piece_position[0]}#{piece_position[1] + 1}"].nil?
        valid_moves << [piece_position[0],
                        piece_position[1] + 1]
      end

      valid_moves.include?(target_position)
    else
      attack_moves = [[1, -1], [-1, -1]]
      valid_moves = attack_moves.map do |column, row|
        [column + piece_position[0], row + piece_position[1]]
      end
                                .select do |column, row|
                                  column.between?(1,
                                                  8) && row.between?(1,
                                                                     8) && !@board.board["#{column}#{row}"].nil? && @board.board["#{column}#{row}"].color != @active_player.color
                                end
      if @board.board["#{piece_position[0]}#{piece_position[1] - 1}"].nil?
        valid_moves << [piece_position[0],
                        piece_position[1] - 1]
      end

      valid_moves.include?(target_position)
    end
  end

  def valid_rook_move?(piece_position, target_position)
    moves = []
    (1..7).each do |num|
      moves << [num, 0]
      moves << [-num, 0]
      moves << [0, num]
      moves << [0, -num]
    end
    valid_moves = moves.map do |column, row|
      [column + piece_position[0], row + piece_position[1]]
    end
                       .select do |column, row|
                         column.between?(1,
                                         8) && row.between?(1,
                                                            8) && (@board.board["#{column}#{row}"].nil? || @board.board["#{column}#{row}"].color != @active_player.color)
                       end
    if valid_moves.include?(target_position)

      return true if target_position[0] - piece_position[0] == 1 || target_position[1] - piece_position[1] == 1

      if target_position[0] - piece_position[0] < 0
        (target_position[0] + 1..piece_position[0] - 1).all? do |y|
          @board.board["#{y}#{target_position[1]}"].nil?
        end
      elsif target_position[0] - piece_position[0] > 0
        (piece_position[0] + 1..target_position[0] - 1).all? do |y|
          @board.board["#{y}#{target_position[1]}"].nil?
        end
      elsif target_position[1] - piece_position[1] < 0
        (target_position[1] + 1..piece_position[1] - 1).all? do |x|
          @board.board["#{target_position[0]}#{x}"].nil?
        end
      elsif target_position[1] - piece_position[1] > 0
        (piece_position[1] + 1..target_position[1] - 1).all? do |x|
          @board.board["#{target_position[0]}#{x}"].nil?
        end
      end
    else
      false
    end
  end

  def pawn_trans?(target_position)
    if target_position[1] == 8 && @active_player.color == 'white'
      true
    elsif target_position[1] == 1 && @active_player.color == 'black'
      true
    else
      false
    end
  end

  def trans_pawn(target_position)
    loop do
      replacement = gets.chomp.downcase

      if @board.board.values.compact.map { |tile| tile.kind }.include?(replacement)
        @board.board["#{target_position[0]}#{target_position[1]}"] = Piece.new(replacement, @active_player.color)
        break
      end
      puts 'Please enter a valid chesspiece name to replace your pawn with'
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

  def valid_move?(piece_position, target_position, kind)
    valid_pawn_move?(piece_position, target_position) if kind == 'pawn'
  end
end

game = GameController.new
game.board.board['24'] = Piece.new('pawn', 'black')
p game.valid_rook_move?([8, 4], [1, 4])

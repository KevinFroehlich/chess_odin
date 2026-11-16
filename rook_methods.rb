require_relative 'chess'

class GameController
  def valid_rook_move?(piece_position, target_position)
    valid_moves = get_valid_rook_moves(piece_position)
    no_pieces_in_rook_path?(valid_moves, piece_position, target_position)
  end

  def get_valid_rook_moves(piece_position)
    moves = []
    (1..7).each do |num|
      moves << [num, 0]
      moves << [-num, 0]
      moves << [0, num]
      moves << [0, -num]
    end
    moves.map do |column, row|
      [column + piece_position[0], row + piece_position[1]]
    end
         .select do |column, row|
           column.between?(1,
                           8) && row.between?(1,
                                              8) && (@board.board["#{column}#{row}"].nil? || @board.board["#{column}#{row}"].color != @active_player.color)
         end
  end

  def no_pieces_in_rook_path?(valid_moves, piece_position, target_position)
    if valid_moves.include?(target_position)
      return true if target_position[0] - piece_position[0] == 1 || target_position[1] - piece_position[1] == 1

      if target_position[0] - piece_position[0] < 0
        (piece_position[0] - 1).downto(target_position[0] + 1).to_a.all? do |y|
          @board.board["#{y}#{target_position[1]}"].nil?
        end
      elsif target_position[0] - piece_position[0] > 0
        (piece_position[0] + 1..target_position[0] - 1).all? do |y|
          @board.board["#{y}#{target_position[1]}"].nil?
        end
      elsif target_position[1] - piece_position[1] < 0
        (piece_position[1] - 1).downto(target_position[1] + 1).to_a.all? do |x|
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
end

require_relative 'chess'

class GameController
  def valid_bishop_move?(piece_position, target_position)
    tpos = target_position

    moves = [1, -1].product([-1, 1])
    moves.each do |move|
      ppos = piece_position.dup
      loop do
        ppos[0] += move[0]
        ppos[1] += move[1]
        break if !ppos.all? do |coord|
          coord.between?(1,
                         8)
        end || (!@board.board["#{ppos[0]}#{ppos[1]}"].nil? && @board.board["#{ppos[0]}#{ppos[1]}"].color == @active_player.color)
        || (!@board.board["#{ppos[0]}#{ppos[1]}"].nil? && ppos != target_position)
        if (!@board.board["#{ppos[0]}#{ppos[1]}"].nil? && ppos == target_position && @board.board["#{ppos[0]}#{ppos[1]}"].color != @active_player.color) || ppos == target_position
          return true
        end
      end
    end
    false
  end

  def get_valid_bishop_moves(piece_position)
    moves = []
    (1..7).each do |num|
      moves << [num, -num].product([-num, num])
    end
    moves.flatten(1).map do |column, row|
      [column + piece_position[0], row + piece_position[1]]
    end
         .select do |column, row|
           column.between?(1,
                           8) && row.between?(1,
                                              8) && (@board.board["#{column}#{row}"].nil? || @board.board["#{column}#{row}"].color != @active_player.color)
         end
  end

  def no_pieces_in_bishop_path?(valid_moves, piece_position, target_position)
    if valid_moves.include?(target_position)
      tarY = target_position[0]
      pieY = piece_position[0]
      tarX = target_position[1]
      pieX = piece_position[1]

      return true if (tarY - pieY == 1 && tarX - pieX == -1) || (pieY - tarY == 1 && pie_x - tarX == 1)

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

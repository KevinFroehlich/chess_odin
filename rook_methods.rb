require_relative 'chess'

class GameController
  def valid_rook_move?(piece_position, target_position)
    tpos = target_position

    moves = [[1, 0], [0, 1], [-1, 0], [0, -1]]
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
end

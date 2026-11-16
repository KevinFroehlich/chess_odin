class GameController
  def valid_knight_move?(piece_position, target_position)
    tpos = target_position
    moves = []
    [2, 1].permutation.each do |a, b|
      [1, -1].product([1, -1]).each do |x, y|
        moves << [a * x, b * y]
      end
    end
    moves.each do |move|
      ppos = piece_position.dup

      ppos[0] += move[0]
      ppos[1] += move[1]
      next if !ppos.all? do |coord|
        coord.between?(1,
                       8)
      end || (!@board.board["#{ppos[0]}#{ppos[1]}"].nil? && @board.board["#{ppos[0]}#{ppos[1]}"].color == @active_player.color)
      || (!@board.board["#{ppos[0]}#{ppos[1]}"].nil? && ppos != target_position)
      if (!@board.board["#{ppos[0]}#{ppos[1]}"].nil? && ppos == target_position && @board.board["#{ppos[0]}#{ppos[1]}"].color != @active_player.color) || ppos == target_position
        return true
      end
    end
    false
  end
end

require_relative 'chess'
class GameController
  def valid_knight_move?(piece_position, target_position)
    get_valid_knight_moves(piece_position).include?(target_position)
  end

  def get_valid_knight_moves(piece_position)
    moves = []
    [2, 1].permutation.each do |a, b|
      [1, -1].product([1, -1]).each do |x, y|
        moves << [a * x, b * y]
      end
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
end

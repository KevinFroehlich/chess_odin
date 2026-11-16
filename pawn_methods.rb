require_relative 'chess'

class GameController
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
end

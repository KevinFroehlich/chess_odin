class GameController
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
end

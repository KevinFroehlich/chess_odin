class GameController
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

  def alternate_player
    @active_player = if @active_player == @p1
                       @p2
                     else
                       @p1
                     end
    puts "Player #{@active_player.color.capitalize}'s turn."
  end
end

class GameController
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
end

class GameController
  def get_piece_position
    loop do
      print 'Choose one of your pieces. Enter a1, b1 etc.'
      piece_position = gets.downcase.chomp
      if piece_position == 'save'
        save_game
        next
      elsif piece_position == 'load'
        load_game
        @board.print_board
        next
      elsif piece_position == 'exit'
        exit
      end
      piece_position = piece_position.split('')
      piece_position[0] = (piece_position[0].ord - 96).to_s
      piece_position = piece_position.join('')

      if !@board.board[piece_position].nil? && @board.board[piece_position].color == @active_player.color
        return piece_position.split('').map(&:to_i)
      end

      puts 'Incorrect input, please choose one of your pieces to move.'
    end
  end

  def get_target_position
    loop do
      print 'Choose a tile to move towards. Enter a1, b1 etc.'
      target_position = gets.downcase.chomp
      if target_position == 'save'
        save_game
        next
      elsif target_position == 'load'
        load_game
        next
      elsif target_position == 'exit'
        exit
      end
      target_position = target_position.split('')
      p target_position[0] = (target_position[0].ord - 96).to_s
      target_position = target_position.join('')

      unless !@board.board.keys.include?(target_position) || !@board.board[target_position].nil? && @board.board[target_position].color == @active_player.color
        return target_position.split('').map(&:to_i)
      end

      puts 'Incorrect input, please choose an empty tile or a tile occupied by an opposing piece as your destination.'
    end
  end
end

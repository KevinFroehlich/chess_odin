class GameController
  def save_game
    File.write('save.yaml', YAML.dump(self))
    puts 'Game saved.'
  end

  def load_game
    game = YAML.unsafe_load_file('save.yaml')
    @active_player = game.active_player
    @board = game.board
    @p1 = game.p1
    @p2 = game.p2
    puts 'Game loaded'
    puts "Player #{@active_player.color}'s turn."
  end
end

require_relative 'rook_methods'
require_relative 'knight_methods'
require_relative 'bishop_methods'
require_relative 'king_methods'
require_relative 'queen_methods'
require_relative 'pawn_methods'
require_relative 'player'
require_relative 'gameboard'
require_relative 'piece'
require_relative 'ai_methods'
require_relative 'get_position_methods'
require_relative 'movement_methods'
require_relative 'misc_methods'
require_relative 'load_save_methods'
require 'yaml'

class GameController
  attr_accessor :p1, :p2, :board, :active_player

  def initialize
    @p1 = Player.new('white')
    @p2 = Player.new('black')
    @board = GameBoard.new
    @active_player = @p1
  end

  def game_loop
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
    end
  end
end

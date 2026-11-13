class Piece
    attr_accessor :kind, :color

    def initialize(kind, color)
        @kind = kind
        @color = color
    end
end

class GameBoard
    attr_accessor :board

    def initialize
        @board = fill_board
    end

    def fill_board
        board = {}
        (3..6).each do |row|
            (1..8).each do |column|
                board["#{column}#{row}"] = nil
                board["#{column}#{2}"] = Piece.new('pawn', 'white')
                board["#{column}#{7}"] = Piece.new('pawn', 'black')
            end
        end
        (1..8).each do |column|
            board["#{column}#{2}"] = Piece.new('pawn', 'white')
            board["#{column}#{7}"] = Piece.new('pawn', 'black')
        end

        [1,8].each do |row|
            (1..8).each do |column|
                board["#{column}#{row}"] = Piece.new('rook', 'white') if ( column == 1 || column == 8) && row == 1
                board["#{column}#{row}"] = Piece.new('rook', 'black') if ( column == 1 || column == 8) && row == 8
                board["#{column}#{row}"] = Piece.new('knight', 'white') if ( column == 2 || column == 7) && row == 1
                board["#{column}#{row}"] = Piece.new('knight', 'black') if ( column == 2 || column == 7) && row == 8
                board["#{column}#{row}"] = Piece.new('bishop', 'white') if ( column == 3 || column == 6) && row == 1
                board["#{column}#{row}"] = Piece.new('bishop', 'black') if ( column == 3 || column == 6) && row == 8
                board["#{column}#{row}"] = Piece.new('queen', 'white') if ( column == 4 ) && row == 1
                board["#{column}#{row}"] = Piece.new('queen', 'black') if ( column == 4 ) && row == 8
                board["#{column}#{row}"] = Piece.new('king', 'white') if ( column == 5 ) && row == 1
                board["#{column}#{row}"] = Piece.new('king', 'black') if ( column == 5 ) && row == 8

            end
        end
        return board
    end
end

class Player
    attr_accessor :color

    def initialize(color)
        @color = color
    end
end

class GameController
    attr_accessor :p1, :p2, :board, :active_player

    def initialize
        @p1 = Player.new('white')
        @p2 = Player.new('black')
        @board = GameBoard.new
        @active_player = @p1
    end

    def alternate_player
        @active_player = @p1 ? @p2 : @p1
    end

    def get_piece_position
        loop do
            piece_position = gets.downcase.chomp.split("")
            piece_position[0] = (piece_position[0].ord - (piece_position[0].ord - 1)).to_s
            piece_position = piece_position.join("")
        
            if @board.board[piece_position] != nil && @board.board[piece_position].color == @active_player.color
                return piece_position.split("").map(&:to_i)
                break
            else
                puts 'Incorrect input, please choose one of your pieces to move.' 
            end
        end
    end

    def get_target_position
        loop do
            target_position = gets.downcase.chomp
            target_position[0] = (target_position[0].ord - (target_position[0].ord - 1)).to_s
            target_position = target_position.join("")

            if @board.board[target_position] == nil || @board.board[target_position].color != @active_player.color
                return target_position.split("").map(&:to_i)
                break
            else
                'Incorrect input, please choose an empty tile or a tile occupied by an opposing piece as your destination.'
            end
        end
    end

    def valid_move?(piece_position, target_position, kind)
    end

    def valid_pawn_move?(piece_position, target_position)
        if @active_player.color == 'white'
            attack_moves = [[1, 1], [1,-1]]
            valid_moves = attack_moves.map do |column, row| 
                [column + piece_position[0], row + piece_position[1]]
            end
            .select { |move| move.all? {|num| num.between?(0,9)} }
        end
            p valid_moves
        
        
    end



    def make_move(tile, color)

    end
end


game = GameController.new



p game.board
p game.valid_pawn_move?([1,1], [1,3])
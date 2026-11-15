require_relative '../chess'

describe Piece do
  it 'initializes an object with the given instance variables' do
    piece = Piece.new('pawn', 'white')
    expect(piece.kind).to eq('pawn')
    expect(piece.color).to eq('white')
  end
end

describe GameBoard do
  describe '#initialize' do
    board = GameBoard.new
    it 'creates a board with 64 squares' do
      expect(board.board.length).to eq(64)
    end

    it 'creates a board with 32 pieces' do
      expect(board.board.values.compact.length).to eq(32)
    end

    it 'creates a board with 32 empty tiles' do
      expect(board.board.values.count(nil)).to eq(32)
    end

    it 'has the correct coordinates' do
      (1..8).each do |column|
        (1..8).each do |row|
          expect(board.board).to have_key("#{column}#{row}")
        end
      end
    end

    it 'places pieces at correct tile' do
      expected_pieces = {
        '11' => %w[white rook],
        '21' => %w[white knight],
        '31' => %w[white bishop],
        '41' => %w[white queen],
        '51' => %w[white king],
        '61' => %w[white bishop],
        '71' => %w[white knight],
        '81' => %w[white rook],
        '18' => %w[black rook],
        '28' => %w[black knight],
        '38' => %w[black bishop],
        '48' => %w[black queen],
        '58' => %w[black king],
        '68' => %w[black bishop],
        '78' => %w[black knight],
        '88' => %w[black rook]
      }
      (1..8).each do |column|
        expected_pieces["#{column}2"] = %w[white pawn]
        expected_pieces["#{column}7"] = %w[black pawn]
      end

      expected_pieces.each do |position, (color, kind)|
        piece = board.board[position]

        expect(piece.color).to eq(color)
        expect(piece.kind).to eq(kind)
      end
    end
  end

  describe Player do
    describe '#initialize' do
      it 'creates a new Player object with the given argument color' do
        player = Player.new('white')
        expect(player.color).to eq('white')
      end
    end
  end

  describe GameController do
    describe '#initialize' do
      it 'creates two new player objects with white and black colors' do
        expect(subject.p1.color).to eq('white')
        expect(subject.p2.color).to eq('black')
      end

      it 'creates a new GameBoard object' do
        expect(subject.board).to be_a(GameBoard)
      end

      it 'initializes p1 as the active player' do
        expect(subject.active_player).to eq(subject.p1)
      end
    end

    describe '#alternate_player' do
      it 'alternates between p1 and p2 as the active player' do
        subject.alternate_player
        expect(subject.active_player).to eq(subject.p2)
        subject.alternate_player
        expect(subject.active_player).to eq(subject.p1)
      end
    end
    describe '#get_piece_position' do
      context 'if the input is incorrect' do
        it 'returns an error message' do
          allow(subject).to receive(:gets).and_return('aa', 'a1')
          expect do
            subject.get_piece_position
          end.to output("Incorrect input, please choose one of your pieces to move.\n").to_stdout
        end
      end

      context 'if the input is correct' do
        it 'returns an array with the input turned into coordinates' do
          allow(subject).to receive(:gets).and_return('a1')
          expect(subject.get_piece_position).to eq([1, 1])
        end
      end
    end

    describe '#get_target_position' do
      context 'if the input is incorrect' do
        it 'returns an error message' do
          allow(subject).to receive(:gets).and_return('aa', 'a1', 'a3')
          expect(subject).to receive(:puts).with('Incorrect input, please choose an empty tile or a tile occupied by an opposing piece as your destination.').twice
          subject.get_target_position
        end
      end

      context 'if the input is correct' do
        it 'returns an array with the input turned into coordinates' do
          allow(subject).to receive(:gets).and_return('a3')
          expect(subject.get_target_position).to eq([1, 3])
        end
      end
    end
    describe '#valid_pawn_move' do
      context 'if the target_position is a valid_move' do
        it 'returns true' do
          expect(subject.valid_pawn_move?([2, 6], [1, 7])).to be(true)
          expect(subject.valid_pawn_move?([2, 6], [3, 7])).to be(true)
          expect(subject.valid_pawn_move?([1, 2], [1, 3])).to be(true)
        end
      end
      context 'if the target_position is not a valid_move' do
        it 'returns false' do
          expect(subject.valid_pawn_move?([2, 6], [2, 7])).to be(false)
          expect(subject.valid_pawn_move?([2, 6], [2, 5])).to be(false)
          expect(subject.valid_pawn_move?([2, 6], [3, 6])).to be(false)
          expect(subject.valid_pawn_move?([1, 2], [1, 4])).to be(false)
        end
      end
    end
    describe '#pawn_trans?' do
      context 'if the active player is white and the target position is in the last row' do
        it 'returns true' do
          expect(subject.pawn_trans?([1, 8])).to be(true)
        end
      end

      context 'if the active player is black and the target position is in the first row' do
        it 'returns true' do
          subject.alternate_player
          expect(subject.pawn_trans?([1, 1])).to be(true)
        end
      end
      context 'if the active player is white and the target position is not in the last row' do
        it 'returns false' do
          expect(subject.pawn_trans?([1, 7])).to be(false)
        end
      end

      context 'if the active player is black and the target position is not in the last row' do
        it 'returns false' do
          subject.alternate_player
          expect(subject.pawn_trans?([1, 7])).to be(false)
        end
      end
    end
    describe '#trans_pawn' do
      context 'if it receives an incorrect input' do
        it 'returns an error message until it gets a correct input' do
          allow(subject).to receive(:gets).and_return('dhaklf', 'queen')
          expect(subject).to receive(:puts).with('Please enter a valid chesspiece name to replace your pawn with').once
          subject.trans_pawn([6, 6])
        end
      end
      context 'if it receives a correct input' do
        it 'creates a new Piece object at the input location with correct kind and color attributes' do
          allow(subject).to receive(:gets).and_return('queen')
          subject.trans_pawn([6, 6])
          expect(subject.board.board['66']).to be_a(Piece)
          expect(subject.board.board['66'].kind).to eq('queen')
          expect(subject.board.board['66'].color).to eq(subject.active_player.color)
        end
      end
    end
    describe '#check_winner?' do
      context 'if the inactive player has no king on the board' do
        it 'returns true' do
          subject.board.board['58'] = nil
          expect(subject.check_winner?).to be(true)
        end
      end
      context 'if the inactive player has a king on the board' do
        it 'returns false' do
          expect(subject.check_winner?).to be(false)
        end
      end
    end
    describe '#valid_move?' do
      context 'if the move is valid and kind is pawn' do
        it 'returns true' do
          expect(subject.valid_move?([1, 2], [1, 3], 'pawn')).to be(true)
        end
      end
      context 'if the move is invalid and kind is pawn' do
        it 'returns true' do
          expect(subject.valid_move?([1, 2], [1, 4], 'pawn')).to be(false)
        end
      end
    end

    describe '#make_move' do
      context 'if the player inputs are a valid move' do
        it 'changes the target_position and piece_position accordingly' do
          allow(subject).to receive(:get_piece_position).and_return([1, 2])
          allow(subject).to receive(:get_target_position).and_return([1, 3])
          subject.make_move
          expect(subject.board.board['12']).to eq(nil)
          expect(subject.board.board['13']).to be_a(Piece)
        end
      end
      context 'if the player inputs are an invalid move' do
        it 'loops an error message until a valid input is given' do
          allow(subject).to receive(:get_piece_position).and_return([1, 2], [1, 2])
          allow(subject).to receive(:get_target_position).and_return([1, 4], [1, 3])
          expect(subject).to receive(:puts).with('Invalid move detected. Please enter a valid move.').once
          subject.make_move
        end
      end
      context 'if the player inputs are valid, the enemy king is black and in reach of the moved pieces next attack' do
        it 'declares a check position' do
          subject.board.board['58'] = nil
          subject.board.board['24'] = Piece.new('king', 'black')
          allow(subject).to receive(:get_piece_position).and_return([1, 2])
          allow(subject).to receive(:get_target_position).and_return([1, 3])
          expect(subject).to receive(:puts).with('Player White says check.').once
          subject.make_move
        end
      end
      context 'if the player inputs are valid, the enemy king is white and in reach of the moved pieces next attack' do
        it 'declares a check position' do
          subject.alternate_player
          subject.board.board['51'] = nil
          subject.board.board['25'] = Piece.new('king', 'white')
          allow(subject).to receive(:get_piece_position).and_return([1, 7])
          allow(subject).to receive(:get_target_position).and_return([1, 6])
          expect(subject).to receive(:puts).with('Player Black says check.').once
          subject.make_move
        end
      end
    end
  end
end

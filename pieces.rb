class Piece
end

module SlidingPieces

  def moves(game_board)
    moves = []
    move_dirs.each do |dir_vert, dir_horz|
      (1..7).each do |multiplier|
        target = [@pos[0] + (dir_vert * multiplier), @pos[1] + (dir_horz * multiplier)]
        moves << target if valid_move?(target, [dir_vert, dir_horz], game_board)
      end
    end
    moves
  end

  def valid_moves(game_board)
    valid_moves = moves(game_board)
    valid_moves.select do |move|
      !game_board.check?(@color, @pos, [move[0], move[1]])
    end
  end

  def valid_move?(target, move_dir, game_board)
    target_vert, target_horz = target
    return false if target_vert < 0 || target_vert > 7 || target_horz < 0 || target_horz > 7

    tested_pos = [@pos[0] + move_dir[0], @pos[1] + move_dir[1]]
    test_vert,test_horz = tested_pos

    until [test_vert, test_horz] == target
      if !game_board.board[test_vert][test_horz].nil?
        return false
      end
      test_vert += move_dir[0]
      test_horz += move_dir[1]
    end

    if !game_board.board[target_vert][target_horz].nil?
      return false if game_board.board[target_vert][target_horz].color == self.color
    end

    true
  end

end

class Rook < Piece
  attr_accessor :color, :pos, :unicode
  include SlidingPieces

  def initialize(pos, color, unicode)
    @pos = pos
    @color = color
    @unicode = unicode
  end

  def move_dirs
    [[-1,0],[0,-1],[0,1],[1,0]]
  end
end

class Queen < Piece
  attr_accessor :color, :pos, :unicode
  include SlidingPieces
  def initialize(pos, color, unicode)
    @pos = pos
    @color = color
    @unicode = unicode
  end



  def move_dirs
    [[-1,0],[0,-1],[0,1],[1,0],[1,1],[-1,-1],[1,-1],[-1,1]]
  end
end

class Bishop < Piece
  attr_accessor :color, :pos, :unicode
  include SlidingPieces
  def initialize(pos, color, unicode)
    @pos = pos
    @color = color
    @unicode = unicode
  end

  def move_dirs
    [[1,1],[-1,-1],[1,-1],[-1,1]]
  end
end

module SteppingPieces

  def moves(game_board)
    moves = []
    curr_vert, curr_horz = @pos
    move_locations.each do |dx, dy|
      target = [curr_vert + dx, curr_horz + dy]
      moves << target if valid_move?(target, game_board)
    end
    moves
  end

  def valid_moves(game_board)
    valid_moves = moves(game_board)
    valid_moves.select do |move|
      !game_board.check?(@color, @pos, [move[0], move[1]])
    end
  end

  def valid_move?(target, game_board)
    target_vert, target_horz = target
    return false if target_vert < 0 || target_vert > 7 || target_horz < 0 || target_horz > 7

    if !game_board.board[target_vert][target_horz].nil?
      return false if game_board.board[target_vert][target_horz].color == self.color
    end

    true
  end
end

class King < Piece
  attr_accessor :color, :pos, :unicode
  include SteppingPieces
  def initialize(pos, color, unicode)
    @pos = pos
    @color = color
    @unicode = unicode
  end



  def move_locations
    [[-1,0],[0,-1],[0,1],[1,0],[1,1],[-1,-1],[1,-1],[-1,1]]
  end
end

class Knight < Piece
  attr_accessor :color, :pos, :unicode
  include SteppingPieces
  def initialize(pos, color, unicode)
    @pos = pos
    @color = color
    @unicode = unicode
  end



  def move_locations
    [[-2,-1],[-2,1],[-1,-2],[-1,2],[1,-2],[1,2],[2,-1],[2,1]]
  end

end

class Pawn < Piece
  attr_accessor :color, :pos, :unicode
  def initialize(pos, color, unicode)
    @pos = pos
    @color = color
    @unicode = unicode
  end

  def moves(game_board)
    curr_vert = @pos[0]
    curr_horz = @pos[1]

    if @color == :white
      move_offsets = [[1,0]]
      if @pos[0] == 1
        move_offsets << [2,0]
      end
    else
      move_offsets = [[-1,0]]
      if @pos[0] == 6
        move_offsets << [-2,0]
      end
    end

    if color == :white
      if !game_board.board[@pos[0] + 1][@pos[1] + 1].nil? && game_board.board[@pos[0] + 1][@pos[1] + 1].color == :green
        move_offsets << [1,1]
      end
      if !game_board.board[@pos[0] + 1][@pos[1] - 1].nil? && game_board.board[@pos[0] + 1][@pos[1] - 1].color == :green
        move_offsets << [1,-1]
      end
    else
      if !game_board.board[@pos[0] - 1][@pos[1] + 1].nil? && game_board.board[@pos[0] - 1][@pos[1] + 1].color == :white
        move_offsets << [-1,1]
      end
      if !game_board.board[@pos[0] - 1][@pos[1] - 1].nil? && game_board.board[@pos[0] - 1][@pos[1] - 1].color == :white
        move_offsets << [-1,-1]
      end
    end

    moves = []
    move_offsets.each do |dx, dy|
      target = [curr_vert + dx, curr_horz + dy]

      moves << target if valid_move?([dx, dy], target, game_board)
    end

    moves
  end

  def valid_moves(game_board)
    valid_moves = moves(game_board)
    valid_moves.select do |move|
      !game_board.check?(@color, @pos, [move[0], move[1]])
    end
  end

  def valid_move?(offset, target, game_board)
    offset_vert, offset_horz = offset
    target_vert, target_horz = target
    return false if target_vert < 0 || target_vert > 7 || target_horz < 0 || target_horz > 7

    if offset_horz == 0
      (1..offset_vert).each do |moves_forward|
        return false if !game_board.board[@pos[0] +  moves_forward][@pos[1]].nil?
      end
    end

    true
  end
end

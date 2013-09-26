
class Board
  attr_accessor :board

  def initialize
    @board = Array.new(8) { Array.new(8) }
    
    

    @board[0] = [Rook.new([0,0], :white, "\u2656"), Knight.new([0,1], :white, "\u2658"), Bishop.new([0,2], :white, "\u2657"),
                 Queen.new([0,3], :white, "\u2655"), King.new([0,4], :white, "\u2654"),
                 Bishop.new([0,5], :white, "\u2657"), Knight.new([0,6], :white, "\u2658"), Rook.new([0,7], :white, "\u2656")]

    @board[1] = [Pawn.new([1,0], :white, "\u2659"), Pawn.new([1,1], :white, "\u2659"), Pawn.new([1,2], :white, "\u2659"),
                 Pawn.new([1,3], :white, "\u2659"), Pawn.new([1,4], :white, "\u2659"), Pawn.new([1,5], :white, "\u2659"),
                 Pawn.new([1,6], :white, "\u2659"), Pawn.new([1,7], :white, "\u2659")]

    @board[6] = [Pawn.new([6,0], :green, "\u2659"), Pawn.new([6,1], :green, "\u2659"), Pawn.new([6,2], :green, "\u2659"),
                Pawn.new([6,3], :green, "\u2659"), Pawn.new([6,4], :green, "\u2659"), Pawn.new([6,5], :green, "\u2659"),
                Pawn.new([6,6], :green, "\u2659"), Pawn.new([6,7], :green, "\u2659")]

    @board[7] = [Rook.new([7,0], :green, "\u2656"), Knight.new([7,1], :green, "\u2658"), Bishop.new([7,2], :green, "\u2657"),
                Queen.new([7,3], :green, "\u2655"), King.new([7,4], :green, "\u2654"),
                Bishop.new([7,5], :green, "\u2657"), Knight.new([7,6], :green, "\u2658"), Rook.new([7,7], :green, "\u2656")]


  end


  def display
    reversed_board = @board.reverse
    reversed_board.each_with_index do |row, row_index|
      print "#{8 - row_index} "
      row.each do |object|
        if object.nil?
          print "\u25A1".colorize(:gray) + " "
        else
          color = object.color
          unicode_format = object.unicode
          print unicode_format.colorize(color) + " "
        end
      end
      puts
    end
    puts "  a b c d e f g h"
  end

  def check_color(move, color)
    pos_vert = move[0][0]
    pos_horz = move[0][1]

    raise InvalidMoveError.new if @board[pos_vert][pos_horz].color != color
  end


  def execute_move(current_pos, intended_pos)
    moving_piece = @board[current_pos[0]][current_pos[1]]
    moving_piece.pos = intended_pos
    @board[intended_pos[0]][intended_pos[1]] = moving_piece
    @board[current_pos[0]][current_pos[1]] = nil

  end

  def execute_valid_move(move)
    current_pos, intended_pos = move[0], move[1]
    if @board[current_pos[0]][current_pos[1]].valid_moves(self).include?(intended_pos)
      execute_move(current_pos, intended_pos)
    else
      raise InvalidMoveError.new
    end

  end

  def check?(color, current_pos = nil, intended_pos = nil)

    if current_pos && intended_pos
      duped_positions = @board.board_dup
      duped_board = Board.new
      duped_board.board = duped_positions
      duped_board.execute_move(current_pos, intended_pos)
      king_pos = duped_board.get_king_pos(color)
      duped_board.board.flatten.each do |square|
        if !square.nil? && square.color != color
          return true if square.moves(duped_board).include?(king_pos)
        end
      end
    else
      king_pos = get_king_pos(color)
      @board.flatten.each do |square|
        if !square.nil? && square.color != color
          return true if square.moves(self).include?(king_pos)
        end
      end
    end

    false
  end

  def get_king_pos(color)
    king_pos = nil
    @board.flatten.each do |square|
      if !square.nil?
        if square.color == color && square.is_a?(King)
          king_pos = square.pos
        end
      end
    end
    king_pos
  end

  def checkmate?(color)
    @board.flatten.each do |square|
      if !square.nil? && square.color == color
        return false if !square.valid_moves(self).empty?
      end
    end
    true
  end

end

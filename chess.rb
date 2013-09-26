require 'colorize'
require_relative 'board'
require_relative 'player'
require_relative 'pieces'

class Game
  attr_accessor :game_board, :player1, :player2, :turn
  def initialize
    @game_board = Board.new
    @player1 = HumanPlayer.new(:white)
    @player2 = HumanPlayer.new(:green)
    @turn = 1
  end

  def play
    until @game_board.checkmate?(player1.color) || @game_board.checkmate?(player2.color)
      @game_board.display
      puts "Check!" if @game_board.check?(player1.color) || @game_board.check?(player2.color)
      begin
        @turn % 2 == 1 ? player = @player1 : player = @player2
        move = player.move(player.color)
        @game_board.check_color(move, player.color)
        @game_board.execute_valid_move(move)
      rescue InvalidMoveError
        retry
      end
      @turn += 1
    end

    game_result
  end

  def game_result
    @game_board.display

    if turn % 2 == 0
      puts "CHECKMATE! #{@player1.color} wins!"
    else
      puts "CHECKMATE! #{@player2.color} wins!"
    end
  end
end

class Array
  def deep_dup
    duped_array = []
    self.each_with_index do |el, idx|
      if el.is_a?(Array)
        duped_array << el.deep_dup
      elsif el.is_a?(Piece)
        duped_piece = el.dup
        duped_pos = el.pos.dup
        duped_piece.pos = duped_pos
        duped_array << duped_piece
      else
        duped_array << nil
      end
    end
    duped_array
  end
end


class InvalidMoveError < StandardError
  def initialize
    puts "Invalid move. Please reenter a move:"
  end
end

chess = Game.new
chess.play
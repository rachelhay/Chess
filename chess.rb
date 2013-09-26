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
    turn % 2 == 0 ? color = @player1.color : color = @player2.color
    puts "CHECKMATE! #{color.capitalize} wins!"
  end
end

class Array
  def board_dup
    duped_board = []
    self.each_with_index do |element, idx|
      if element.is_a?(Array)
        duped_board << element.board_dup
      elsif element.is_a?(Piece)
        duped_piece = element.dup
        duped_pos = element.pos.dup
        duped_piece.pos = duped_pos
        duped_board << duped_piece
      else
        duped_board << nil
      end
    end
    duped_board
  end
end


class InvalidMoveError < StandardError
  def initialize
    puts "Invalid move. Please re-enter a move:"
  end
end

chess = Game.new
chess.play
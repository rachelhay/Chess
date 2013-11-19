class HumanPlayer
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def move(color)
    puts "#{color} move: "

    puts "What piece would you like to move? e.g. 'e2'"
    start_pos = gets.chomp.split("")
    start_pos = validate_coordinates(start_pos)

    puts "Where would you like to move it to? e.g. 'e4'"
    end_pos = gets.chomp.split("")
    end_pos = validate_coordinates(end_pos)

    [start_pos, end_pos]
  end

  def validate_coordinates(pos)
    if ("a".."h").include?(pos[0])
      col = pos[0]
      if (1..8).include?(pos[1].to_i)
        row = pos[1].to_i
      else
        raise InvalidMoveError
      end
    else
      raise InvalidMoveError
    end

    col = ('a'..'h').to_a.index(col)
    row -= 1

    [row, col]
  end

end
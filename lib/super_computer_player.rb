require_relative 'tic_tac_toe_node'

class SuperComputerPlayer < ComputerPlayer
  def move(game, mark)
    ttt_node = TicTacToeNode.new(game.board, mark)

    child_nodes = ttt_node.children

    child_nodes.each do |child_node|
      return child_node.prev_move_pos if child_node.winning_node?(mark)
    end

    child_nodes.each do |child_node|
      return child_node.prev_move_pos unless child_node.losing_node?(mark)
    end

    raise Exception.new("Bad AI!!!")

  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Play the brilliant computer!"
  hp = HumanPlayer.new("Jeff")
  cp = SuperComputerPlayer.new

  TicTacToe.new(hp, cp).run
end

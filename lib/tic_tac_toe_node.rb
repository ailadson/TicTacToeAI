require_relative 'tic_tac_toe'
require "byebug"

class TicTacToeNode
  attr_reader :board,  :prev_move_pos
  attr_accessor :next_mover_mark

  def self.swap_mark(mark)
    (mark == :x) ? :o : :x
  end

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end


  # Clean up boolean expressions
  def losing_node?(evaluator)
    if board.over?
      return false if (board.winner == evaluator || board.tied?)
      return true if (board.winner == TicTacToeNode.swap_mark(evaluator))
    end

    # conditional to check whose turn it is
    if evaluator == next_mover_mark
      # if it's my turn, and all my moves cause me to lose
      return children.all? { |node| node.losing_node?(evaluator) }
    else
      # if it's the other person's turn, and any of his moves cause me to lose
      return children.any? {|node| node.losing_node?(evaluator)}
    end
  end

  def winning_node?(evaluator)
    if board.over?
      return false if (board.winner == TicTacToeNode.swap_mark(evaluator) || board.tied?)
      return true if (board.winner == evaluator)
    end

    if next_mover_mark == evaluator
      return children.any? { |node| node.winning_node?(evaluator) }
    else
      return children.all? { |node| node.winning_node?(evaluator) }
    end
  end

  # This method generates an array of all moves that can be made after
  # the current move.

  def children
    nodes = []
    board.rows.each_with_index do |row, idx1|
      row.each_with_index do |pos, idx2|
        if pos.nil?
          new_board = board.dup
          pos = [idx1, idx2]
          # debugger
          new_board[pos] = next_mover_mark
          nodes << TicTacToeNode.new(new_board, TicTacToeNode.swap_mark(next_mover_mark),  pos)
        end
      end
    end
    nodes
  end
end

require 'pry'

class Game
  def start
    play(board)
  end

  private

  WIN_COMBINATIONS = [
    [0, 1, 2], # top_row
    [3, 4, 5], # middle_row
    [6, 7, 8], # bottom_row
    [0, 3, 6], # left_column
    [1, 4, 7], # center_column
    [2, 5, 8], # right_column
    [0, 4, 8], # left_diagonal
    [6, 4, 2] # right_diagonal
  ]

  def board
    ['1', '2', '3', '4', '5', '6', '7', '8', '9']
  end

  def display_board(board)
    puts " #{board[0]} | #{board[1]} | #{board[2]} "
    puts "-----------"
    puts " #{board[3]} | #{board[4]} | #{board[5]} "
    puts "-----------"
    puts " #{board[6]} | #{board[7]} | #{board[8]} "
  end

  # Human readable index need to be converted to computer readable
  # 1,2,3,4,5,6,7,8,9 -> 0,1,2,3,4,5,6,7,8
  def input_to_index(user_input)
    user_input.to_i - 1
  end

  def move(board, index, player)
    board[index] = player
  end

  # Validate if selected index is taken or not
  def position_taken?(board, index)
    if (board[index] == " ") || (board[index] == "") || (board[index] == nil) || ((1..9).to_a.include?(board[index].to_i))
      return false
    else
      return true
    end
  end

  # Check if user input is between 1-9 and position needs to be empty
  def valid_move?(board, index)
    if index.between?(0, 8) && !position_taken?(board, index)
      return true
    else
      return false
    end
  end

  def current_player(board)
    turn_count(board) % 2 == 0 ? "X" : "O"
  end

  def turn_count(board)
    counter = 0
    board.each do |spaces|
      if spaces == "X" || spaces == "O"
        counter += 1
      end
    end
    counter
  end

  def turn(board)
    display_board(board)
    puts "Please enter 1-9:"
    user_input = gets.strip
    index = input_to_index(user_input)
    if valid_move?(board, index)
      move(board, index, current_player(board))
    else
      turn(board)
    end
  end

  def won?(board)
    WIN_COMBINATIONS.each do |win_combination|
      win_index_1 = win_combination[0] # [0,1,2], # top_row
      win_index_2 = win_combination[1] # [3,4,5], # middle_row
      win_index_3 = win_combination[2] # [6,7,8], # bottom_row

      position_1 = board[win_index_1] # value of board at win_index_1
      position_2 = board[win_index_2] # value of board at win_index_2
      position_3 = board[win_index_3] # value of board at win_index_3

      if position_1 == position_2 && position_2 == position_3 && position_taken?(board, win_index_1)
        return win_combination
      end
    end
    return false
  end

  def full?(board)
    board.all? { |i| i == "X" || i == "O" }
  end

  def draw?(board)
    if !won?(board) && full?(board)
      return true
    elsif !won?(board) && !full?(board)
      return false
    else
      won?(board)
      return false
    end
  end

  def over?(board)
    if draw?(board) || won?(board) || full?(board)
      true
    end
  end

  def winner(board)
    if won?(board)
      return board[won?(board)[0]]
    end
  end

  def play(board)
    until over?(board)
      turn(board)
    end
    if won?(board)
      winner(board) == "X" || winner(board) == "0"
      puts "Congratulations #{winner(board)}!"
    elsif draw?(board)
      puts "Cat's Game!"
    end
  end

end

g = Game.new
# board = g.board
g.start

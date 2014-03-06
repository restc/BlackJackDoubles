# AckJack.rb
# class Bank

# A temporary authority to hold money until a winner is found

class Bank
  attr_accessor :balance

  def initialize
    @balance = 0
  end

  def deposit(bet)
    @balance += bet
  end

  def withdraw(winner)
    # winner here is the player object
    winner.purse.balance += @balance
    @balance = 0
  end
end
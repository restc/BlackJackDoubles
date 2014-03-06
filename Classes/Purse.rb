# AckJack.rb
# class Purse

class Purse
  attr_reader :balance

  def initialize(value=1000)
    @balance = value
  end

  def add_winnings(winnings)
    @balance += winnings
  end

  def subtract_bet(bet)
    @balance -= bet
  end

  def rich_enough?(bet)
    @balance >= bet
  end
end

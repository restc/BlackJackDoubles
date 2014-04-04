# BlackJackDoubles.rb
# class Bank

# A temporary authority to hold money until a winner is found

class Bank
  attr_accessor :balance

  def initialize
    # This is where funds are temporarily held between game start and awarding a winner
    # There should only be a balance as long as there is a game in progress
    @balance = 0
  end

  def deposit(bet)
    @balance += bet
  end

  def payout(winner, multiplier)
    # winner here is the player object
    factor = self.multiplier(multiplier)
    winnings = @balance * factor
    winner.purse.add_winnings(winnings)
    @balance = 0
    winnings
  end

  def multiplier(number_of_hands)
    case number_of_hands
    when 1
      1
    when 2
      1.5
    when 3
      2
    when 4
      5
    when 5
      10
    when 6
      20
    when 7
      50
    when 8
      80
    when 9
      99
    when 10
      1000
    end
  end

end

# AckJack.rb 
# class Player

class Player
  
  attr_reader :name
  attr_accessor :purse, :hand, :hands, :score, :busted, :stand, :split, :bet

  alias :points :score

  def initialize name
    @name = name

    @hand = Hand.new
    @hands = Array.new
    @purse = Purse.new
    @bet = 0

    @busted, @stand, @split = false, false, false

    @hands << @hand
    @hands.flatten!
  end

  def busted?
    # Call Hand method #unfinished
  end

  def stand?(stand=false)
    @stand = stand
  end

  def score
    self.hand.points
  end

  def multiple_hands(default=false)
    @split = default
  end

  def split(cards_to_move)
    @hands << @hand.cards.shift()
    @hands.flatten!
  end

  def set_bet(bet)
    @bet = bet
  end

  def bet
    @bet
  end

end
# AckJack.rb
# class Player

class Player

  attr_reader :name
  attr_accessor :purse, :hands, :score, :busted, :bet, :points

  alias :score :points

  def initialize name
    @name = name

    @hands = HandCollection.new
    hand = Hand.new

    @purse = Purse.new
    @bet = nil
    @busted = false

    @hands.collection << hand
    @hands.collection.last.cards.flatten!
  end

  def busted?
    size_of_hand = self.hands.length
    hands_over_21 = []
    self.hands.each do |hand|
      if hand.busted? == true
        hands_over_21 << true
      else
        hands_over_21 << false
      end
    end
    # Find the length of hands busted, and if it is the same as the number of hands, player is bust
    unless hands_over_21.select {|t| t == true}.length == hands_over_21
      @busted == false
    else
      @busted == true
    end
  end

  def declare_bust
    # Calling declare_bust will automatically mark the player's hand as busted
    @busted = true
  end

  def stand?(stand=false)
    self.stand = stand
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

  def bet
    @bet
  end

  def double_bet
    @bet *= 2
  end

end

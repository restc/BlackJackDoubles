class HandWatcher # Observer of Hand objects
  def initialize(hand)
    hand.add_observer(self)
  end
end

class HandDouble < HandWatcher
  def update(player, hand, card)
    if hand.match?
      player.hands.collection.new(card)

    end
  end
end

class HandBusted < HandWatcher
  def update(player, hand)
    if hand.points > 21
      hand.delcare_bust(true)
    end
  end
end

class AceReduce < HandWatcher
  def update(hand)
    unless hand.points > 21
      hand.reduce_ace
    end
  end

  def reduce_ace
    self.cards.each do |card|
      unless card.reduce != true
        card.number = 1
      end
    end
  end
end

require 'pp'

class Notify
  def message(input, *args)
    pp input
    args = []
  end

  def handWasDoubled(args)
    puts "The hand was doubled!"
  end
end

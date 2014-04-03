# BlackJackDoubles.rb
# class Hand
require "observer"

class Hand
  include Observable
  include Enumerable

  attr_reader :busted, :cards, :stand

  def initialize(card=nil)
    @cards = Array.new
    unless card != nil
      unless !card.is_a? Card
        @cards << card
      end
    end
    @busted = false
    # add_observer(HandDouble.new(self)) # Not currently implemented
    # add_observer(AceReduce.new(self))
  end

  def draw dealt_cards
    @cards << dealt_cards
    @cards.flatten!
  end

  def points
    unless self.class.is_a? Hand
      self.cards.map {|card|
        case card.number
        when 11
          10
        when 12
          10
        when 13
          10
        when 14
          11
        when nil
          0
        else
          card.number
        end
      }.inject(:+)
    end
  end

  def aces
    aces = 0
    self.cards.map {|card|
      if card.number == 14
        aces += 1
      end
    }
    aces
  end

  def cards_in_hand
    self.cards.length
  end

  def pretty_print
    pretty_card = nil
    self.cards.each do |card|
      case
      when card.number == 11
        pretty_card = "J of #{card.suit}"
      when card.number == 12
        pretty_card = "Q of #{card.suit}"
      when card.number == 13
        pretty_card = "K of #{card.suit}"
      when card.number == 14
        pretty_card = "A of #{card.suit}"
      else
        pretty_card = "#{card.number} of #{card.suit}"
      end
      puts pretty_card
    end
  end

  def split(player, hand)
    # Use in response to match?
    unless hand.is_a? Hand
      return BlackJackDoublesErrors.splitERROR
    end
    initial_card = hand.cards.shift(1)
    player.hands.collection.new(initial_card)
    player.double_bet
    puts "#{player.name}, your hands split and your bet was doubled"
  end

  def busted?
    self.points > 21
  end

  def declare_bust(default=false)
    @busted = default
  end

  def has_ace?
    aces = 0
    self.cards.each do |ace|
      if ace.number == 14
        aces += 1
      end
    end
    # puts "#{aces} aces"
    aces == 0 ? false : aces
  end

  def stand?(default=false)
    @stand ||= default
  end

  def match?
    numbers = Array.new
    self.cards.map {|card|
      numbers << card.number
    }
    numbers.flatten!
    return true unless (numbers.uniq == numbers.length)
  end

  def reduce_ace
    self.cards.each do |card|
      if card.number == 14
        card.number = 1
        #unfinished – Add watcher to check for ace reduction to keep track
      end
    end
  end

end #class

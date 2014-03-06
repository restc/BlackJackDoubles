# AckJack.rb
# class Deck

class Deck
  # Allow Enumerable methods to be used on Arrays
  include Enumerable

  attr_reader :deck

  def initialize
    deck = Array.new
    suits.each do |suit|
      numbers.each do |number|
        deck.push Card.new(suit, number)
      end
    end
    @deck = deck.shuffle
  end

  def suits
    Card::VALID_SUITS
  end

  def numbers
    Card::VALID_NUMBERS
  end

  def self.shuffle
    random = Random.new
    shuffled = Array.new
    52.times do
      shuffled << random.rand(52)
    end
    shuffled
  end

end



# BlackJackDoubles.rb
# class Deck

class Deck
  # Allow Enumerable methods to be used on Arrays
  include Enumerable

  attr_reader :cards

  def initialize
    cards = Array.new
    suits.each do |suit|
      numbers.each do |number|
        cards.push Card.new(suit, number)
      end
    end
    @cards = cards.shuffle
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

  def serve(num_cards)
    cards.shift(num_cards)
  end

end

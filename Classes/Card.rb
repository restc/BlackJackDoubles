# AckJack.rb
# class Card


class Card
  attr_reader :number, :suit

  def initialize(suit, number)
    @suit, @number = suit, number
  end

 def print
    case self.number
    when 11
      puts "Jack of #{self.suit}"
    when 12
      puts "Queen of #{self.suit}"
    when 13
      puts "King of #{self.suit}"
    when 14
      puts "Ace of #{self.suit}"
    else
      puts "#{self.number} of #{self.suit}"
    end
  end

  def print_number
    case self.number
    when 11
      10
    when 12
      10
    when 13
      10
    when 14
      11
    else
      self.number
    end
  end

  private
  VALID_NUMBERS = (2..14).to_a
  VALID_SUITS = ["Hearts", "Spades", "Diamonds", "Clubs"] 

end
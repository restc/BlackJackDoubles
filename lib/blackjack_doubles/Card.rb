# AckJack.rb
# class Card

module BlackjackDoubles
  class Card
    attr_accessor :number
    attr_reader :suit, :reduce

    def initialize(suit, number)
      unless !VALID_SUITS.include?(suit.downcase.capitalize)
        unless !VALID_NUMBERS.include?(number)
          case number
          when 14
            @suit, @number, @reduce = suit, number, false
          else
            @suit, @number = suit, number
          end
        else
          value_error
        end
      else
        suit_error
      end
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

    def value_error
      puts "Out of bounds – card must be within #{VALID_NUMBERS.map {|x|}}"
    end

    def suit_error
      suits = VALID_SUITS.map {|x| puts x}
      puts "To be a real card, it must be a #{suits}."
    end

    private
    VALID_NUMBERS = (2..14).to_a
    VALID_SUITS = ["Hearts", "Spades", "Diamonds", "Clubs"]

  end
end

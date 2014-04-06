# AckJack.rb
# class HandCollection

module BlackjackDoubles
  class HandCollection < Hand
    include Enumerable
    attr_accessor :collection

    def initialize
      @collection = Array.new
    end

    def new(card)
      @collection << Hand.new
      @collection.last.cards << card
    end

    def split(hand)
      moveCard = hand.cards.shift(1)
      new(moveCard)
    end

    def size
      @collection.length
    end

    def flush
      @collection = HandCollection.new
    end

    def
      @collection.size
    end

  end
end

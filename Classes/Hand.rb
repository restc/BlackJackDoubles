# AckJack.rb
# class Hand
require "observer"

class Hand
  include Observable

  attr_reader :busted, :cards, :hand_object

  def initialize
    @cards = Array.new
    @busted = false
  end

  def draw dealt_cards
    if dealt_cards.length > 1
      dealt_cards.each do |card|
        self.cards << card
      end
    else
      self.cards << dealt_cards
    end
    notify_observers
    self.cards.flatten!
  end

  def points
    unless self.class != Hand
      self.cards.map {|card|
        case card.number
        when 11 # Value for Jack
          10
        when 12 # Value for Queen
          10
        when 13 # Value for King
          10
        when 14 # Value for Ace
          11
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
      case card.number
      when 11
        pretty_card = {card.suit => card.number=10}
      when 12
        pretty_card = {card.suit => card.number=10}
      when 13
        pretty_card = {card.suit => card.number=10}
      when 14
        pretty_card = {card.suit => card.number=11}
      else
        pretty_card = {card.suit => card.number}
      end
      puts pretty_card
    end
  end

  # Split hand methods
  def move_cards(org_hand, card_pos, tar_hand)
    shiftHands = @hands[org_hand].pop(card_pos)
    @hands[tar_hand].push(shiftHands)
  end

  def autosplit?
    # Watcher for when a hand has two cards of the same number
    case @cards.length
    when 2
      if @cards.first.number == @cards.last.number
        true
      else
        false
      end
    end
  end


  private
  def hand_object
    self.object_id
  end

end #class



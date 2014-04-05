# AckJack.rb
# observer methods

module BlackjackDoubles
  class Notifier
    def update(hand, points)
      case
      when points > 21
        puts "Your hand busted with a score of #{hand.points}!"
      else
        puts "Good job"
      end
    end
  end
end

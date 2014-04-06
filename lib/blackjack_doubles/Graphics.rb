
module BlackjackDoubles
  class Graphics

    def print_grid(hands)
      puts ""
      unless hands.is_a? HandCollection
        puts "Please only pass in the `HandsCollection` object [player.hands]."
      end
      hands.collection.each_with_index do |hand, index|
        puts %Q{\t|\tHAND #{index+1}\t\t\t|\n\t|\t\t\t\t|}
        unless hand.cards.nil?
          hand.cards.each do |card|
            case card.number
            when 11
              puts "\t|\tJack of #{card.suit}\t\t|"
            when 12
              puts "\t|\tQueen of #{card.suit}\t\t|"
            when 13
              puts "\t|\tKing of #{card.suit}\t\t|"
            when 14
              puts "\t|\tAce of #{card.suit}\t\t|"
            else
              puts "\t|\t#{card.number} of #{card.suit}\t\t|"
            end
          end

          puts %Q{\t|\t\t\t\t|\n\t|\t(#{hand.points} points)\t\t|\n\t_____________________________}
        end
        if hand.cards.nil?
          puts "\t|\tNo cards\t\t|"
        end
      end
    end

  end
end

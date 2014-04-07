
module BlackjackDoubles
  class Graphics

    def print_grid(player)
      puts ""
      unless player.hands.is_a? HandCollection
        puts "Please only pass in the `HandsCollection` object [player.hands]."
      end
      player.hands.collection.each_with_index do |hand, index|
        puts %Q{\n\t _______________________________\n\t|\t\t\t\t|}
        puts %Q{\t|\tPLAYER #{player.name}\t\t|\n\t|\tHAND #{index+1}  –  #{hand.points} points\t|\n\t|\t\t\t\t|}
        unless hand.cards.nil?
          hand.cards.each do |card|

            case card.number
            when 11
              puts "\t|\tJ of #{card.suit}\t\t|"
            when 12
              puts "\t|\tQ of #{card.suit}\t\t|"
            when 13
              puts "\t|\tK of #{card.suit}\t\t|"
            when 14
              puts "\t|\tA of #{card.suit}\t\t|"
            else
              puts "\t|\t#{card.number} of #{card.suit}\t\t|"
            end
          end

          puts %Q{\t|\t\t\t\t|\n\t|\t\t\t\t|\n\t _______________________________\n}
        end
        if hand.cards.nil?
          puts "\t|\tNo cards\t\t|"
        end
      end
    end

    def self.game_banner
      puts <<-BANNER


      \t  ####  #     ###    ###  #  ##  #####  ###    ###  #  ##
      \t  #  ## #    #   #  #     # ##     #   #   #  #     # ##
      \t  ####  #    #####  #     ##       #   #####  #     ##
      \t  #  ## #    #   #  #     # ##     #   #   #  #     # ##
      \t  ####  #### #   #   ###  #  ##  ##    #   #   ###  #  ##

      \t\t####    ###   #   #  ###   #    ####  ###
      \t\t#   #  #   #  #   #  #  #  #    #     #
      \t\t#   #  #   #  #   #  ###   #    ###   ###
      \t\t#   #  #   #  #   #  #  #  #    #       #
      \t\t####    ###    ###   ###   #### ####  ###
      BANNER
    end

  end
end

# (#{hand.points} points)

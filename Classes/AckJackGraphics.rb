# AckJack.rb
# class Graphics


class AckJackGraphics

  def print_grid(hands)
    puts ""
    unless hands.is_a? Array
      puts "Please only pass in a `Hands` object."
    end
    hands.each_with_index do |hand, index|
      puts %Q{\t|\tHAND #{index+1}\t\t\t|\n\t|\t\t\t\t|}
      case 
      when hand.cards.length > 1
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
      when hand.cards.length == 1
        card = hand.cards.first
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
        puts %Q{\t|\t\t\t\t|\n\t|\t(#{hand.points} points)\t\t|\n\t_____________________________}
      when hand.cards.length == 0
        puts "\t|\tNo cards\t\t|"
      end

    end 
  end

end
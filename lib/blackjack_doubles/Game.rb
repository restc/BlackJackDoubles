require 'observer'

module BlackjackDoubles
  class Game

    include Observable
    attr_reader :deck, :players, :winner, :names, :bank, :hand_objects

    MINIMUM_BET = 20

    def initialize(first_run=true)
      case first_run
      when true
        system 'clear'
        Graphics.game_banner
        top_margin
        unless self.read_instructions? == false
          self.read_instructions
        end
        players = Array.new
        names = self.get_names
        names.each do |name|
          players << Player.new(name)
        end

        @names = names
        @players = players
        @deck = self.make_deck
        @bank = Bank.new
      when false
        @players = @players
        @deck = self.make_deck
        @bank = @bank
      end
    end

    def make_deck
      Deck.new
    end

    def get_names
      system 'clear'
      top_margin
      puts "What are your names, players?"
      names = gets.chomp

      if names.is_a?(String) && names.include?(' ')
        names = names.split(' ')
      elsif names.is_a?(String) && names.include?(',')
        names = names.split(',')
      elsif names.is_a?(String) && names.include?('and')
        names = names.split('and')
      elsif names.is_a?(String) && names.include?('&')
        names = names.split('&')
      elsif names.is_a?(String) && names.include?('&&')
        names = names.split('&&')
      elsif names.is_a?(String) && names.include?(',')
        names = names.split(',')
      else
        puts "Please enter your names, split by a comma or space, "
        puts "such as: Washington Lincoln, or: Skywalker, Solo"
        self.get_names
      end
      names
    end

    def get_score player
      player.hand.score
    end

    def deal
      # This method deals with initial deal
      @players.each do |player|
        cards = @deck.serve(2)
        # Find if cards are of the same number
        # If they are, distribute card 1 to first hand and card 2 to second
        if cards.first.number == cards.last.number
          player.hands.collection.first.draw(cards.first)
          player.hands.new(cards.last)
        else
          player.hands.collection.first.draw(cards)
        end
      end
    end

    def split(player, hand)
      player.hands.new(hand.cards.shift(1))
    end

    def hit(player, hand)
      # This method is used when a player wants an additional card
      servedCard = @deck.serve(1)
      servedCard = servedCard.first
      if match_served_card(hand, servedCard) == true
        player.hands.new(servedCard)
        player.double_bet
        puts "Split #{player.name}'s hand and doubled your bet to #{player.bet}"

      else
        hand.cards << servedCard
        hand.cards.flatten!
      end
    end

    def match_served_card(hand, card)
      hand.cards.flatten!
      match = hand.cards.map {|c| c.number}
      match.flatten!
      if match.include? card.number
        true # Returns true when split hand
      else
        false # Returns false when hand should not split
      end
    end

    def hit?(player, hand)
      #Instead of hand.pretty_print... try self.scoreboard(player)
      #hand.pretty_print
      system 'clear'
      self.scoreboard(player)
      unless hand.stand? == true
        case
        when (hand.points > 21 && hand.has_ace?)
          puts "\n#{player.name}, you have over 21 points in this hand: #{hand.points} points"
          hand.reduce_ace
          puts "Let's make your ace worth 1 instead of 11. Now you have #{hand.points} points."
          self.hit?(player, hand)
        when (hand.points > 21 && hand.has_ace? == false)
          puts "\n#{player.name}, your hand is bust: #{hand.points} points."
          hand.declare_bust(true)
        when hand.points < 21

          puts "\nYou have #{hand.points} points in this hand. \n\nYou can [h]it or [s]tand."

          input = gets.chomp
          if 'h'.include? input
            self.hit(player, hand)
            hand.stand?(stand=false)
            self.hit?(player, hand)
          elsif 's'.include? input
            hand.stand?(stand=true)
          else
            puts "Type [h] to hit, or [s] to stand."
            self.hit?(player, hand)
          end
        when hand.points == 21
          puts "Blackjack! You have as many points as possible with this hand!"
        end
      end
    end

    def read_instructions?
      puts "Would you like an explanation of how to play?"
      input = gets.chomp
      if ['y', 'yes'].include? input.downcase
        true
      else
        false
      end
    end

    def self.print_hand_objects
      self.hand_objects.each do |pname|
        pname.each do |hand_o|
          puts hand_o
        end
      end
    end

    def read_instructions
      system 'clear'
      puts <<-PARAGRAPH

      BlackJackDoubles is a spinoff of the popular card game Blackjack. It requires
      two players and a neutral dealer to play.

      When starting the game, both players set an initial bet. They are then dealt two
      cards each, face up, so that both may see the other player's hand. A hand is a
      collection of cards that does not have duplicate numbers. When you're dealt a
      duplicate, your hand splits, and your initial bet will double. Like Blackjack,
      you win if you score 21 points, or if you have a higher score than the other
      player's corresponding hand while staying under 21.

      If you are dealt a duplicate card to your hand, your hand will automatically
      split. When you split a hand, your bet also doubles. At the end of the game,
      whether you stop betting or you run out of cards, your hands will be compared to
      your opponent's hands, the best against the best, and the winner will receive
      the prize money, with a bonus if you've played more than one hand that didn't
      bust.

      You'll both start out with 1000g, and the minimum bet to play is 20g.
      Good luck!


      * Press [Enter] to continue *
      PARAGRAPH
      STDIN.gets

    end

    def play
      gameplay_intro
      gameplay_logic
    end

    def bet
      @players.each do |player|
        unless player.bet != nil
          system 'clear'
          puts <<-PARAGRAPH
          #{top_margin}
          #{player.name},
          The minimum bet is 20g. You have #{player.purse.balance}g.

          What will you wager?

          PARAGRAPH
          wager = gets.chomp.to_i
          while wager < MINIMUM_BET
            puts "The minimum bet is #{MINIMUM_BET}. Enter your bet: \n"
            wager = gets.chomp.to_i
          end

          player.bet = wager
          player.purse.subtract_bet(wager)
          @bank.deposit(wager)

        else
          puts "#{player.name}, you have already bet #{player.bet}."
        end
      end
    end

    def scoreboard(player=nil)
      graphics = Graphics.new
      if player == nil
        @players.each do |player|
          graphics.print_grid(player)
        end
      else
        graphics.print_grid(player)
      end
    end

    def double_bet(player)
      # Allow each player to double the bet before choosing to hit or stand
      system 'clear'
      puts "\n\n\n"
      puts "Would you like to double your bet before hitting?"
      puts "Please type [y] to bet, or press any other key.\n"
      double = gets.chomp
      if 'y'.include? double.downcase
        system 'clear'
        player.double_bet
        puts "Your bet is set at #{player.bet} per hand.\n\n"
      else
        system 'clear'
        puts "Your bet is set at #{player.bet} per hand.\n\n"
      end
    end

    def gameplay_intro
      system 'clear'
      puts "\n\n\tYou have to bet to get into the game"

      # Verify both players have made a bet
      system 'clear'
      self.bet

      # After both players have bet, deal then print current state of affairs
      self.deal
      system 'clear'
      self.scoreboard

      # Continue
      puts "\n\nPress [Enter] key to continue... "
      continue = gets.chomp
    end

    def gameplay_logic
      # Gameplay rules, certainly could be broken down better. Hackety hack etc.

      @players.each do |player|
        system 'clear'
        puts "\nIt is now #{player.name}'s turn."
        puts "Press [Enter] to continue... "
        continue = gets.chomp

      # Allow each player to double the bet before choosing to hit or stand
        system 'clear'
        puts "\n\n\n"
        puts "Would you like to double your bet before hitting?"
        puts "Please type [y] to double bet, or press any other key.\n"
        double = gets.chomp
        if 'y'.include? double.downcase
          system 'clear'
          player.double_bet
          puts "Your bet is set at #{player.bet} per hand.\n\n"
        else
          system 'clear'
          puts "Your bet is set at #{player.bet} per hand.\n\n"
        end

      # Prompt each player to hit or stand per hand
        self.gameplay_hit_or_stand(player)

        if player == @players.first
          puts "Press [Enter] before #{@players.last.name} begins."
          continue = gets.chomp
        end
      end # End players loop
      self.declare_winner
      sleep(5)
      self.play_again
    end

    def gameplay_hit_or_stand(player)
      hands = player.hands.collection
      hands.each do |hand|
        unless hand.stand? == true
          case hand.points <=> 21
          when -1
            self.hit?(player, hand)
          when 0
            puts "Win! #{player.name}, you have 21 points!"
          when 1
            puts "#{player.name} busted with #{hand.points}."
          end
        end
      end
      unless hands.each {|hand| hand.stand? == true || hand.busted? == true}
        self.gameplay_hit_or_stand(player)
      end
    end

    def largest_hand_collection
      hand_length = nil

      compare = @players.map {|player| player.hands.collection.length }.inject(:<=>)
      case compare
      when 1
        hand_length = @players.first.hands.collection.length
      when -1
        hand_length = @players.last.hands.collection.length
      when 0
        hand_length = @players.first.hands.collection.length
      end
      hand_length
    end

    def score_hands
      score = Array.new
      largest_hand_collection.each do |lhc|
        result = (@players.first.hands.collection[x].points <=>   self.players.last.hands.collection[x].points)
        puts "Hand #{lhc+1} :"
        puts "#{@players.first.name} #{@players.first.hands.collection[x].points}"
        puts "#{@players.last.name} #{@players.last.hands.collection[x].points}"
        case result
        when 1
          score << [@players.first.name, @players.first.hands.collection[x].points]
        when 0
          score << ['Tie', @players.first.hands.collection[x].points]
        when -1
          score << [@players.last.name, @players.last.hands.collection[x].points]
        end
      end
      score
    end

    def top_margin
      puts "\n\n"
    end

    def find_winner(player)
      result = Array.new
      player.hands.collection.each_with_index do |hand, index|
        index += 1
        result.push(["Hand #{index}", hand.points])
      end
      result.flatten!
    end

    def winning_score
      puts "\t Players \t Hand \t\t Score \t\t Won \t"
      @players.each do |player|
        player.hands.collection.each_with_index do |hand, index|
          puts "\t #{player.name} \t\t #{index+1} \t\t #{hand.points} \t #{}"
        end
      end
    end

    def hands
      hands = Array.new
      players << @players.each {|pl| p pl }
      players.each_with_index {|player, i|
        case player
        when player[i].name == @players.first.name
          hands[i+1].insert(player.hands[i].points)
        when player[i].name == @players.last.name
          hands[i+1].insert(player.hands[i].points)
        end
      }
      hands
    end

    def declare_winner
      scorechart = {}
      scorechart["Player 1"] = @players.first.hands.collection.map {|hand| hand.points}.drop_while {|num| num > 21}.sort
      scorechart["Player 2"] = @players.last.hands.collection.map {|hand| hand.points}.drop_while {|num| num > 21}.sort

      result = (scorechart["Player 1"] <=> scorechart["Player 2"])
      case result
      when 1
        winnings = @bank.payout(@players.first)
        puts "Player 1 wins! #{@players.first.name} wins #{winnings}g with #{@players.first.hands.hands_not_busted} hands."
      when 0
        puts "Deadlocked Tie. No one wins."
        @secret_bank = @bank.balance
        @bank.balance = 0
        # winnings = @bank.balance
        # partial = winnings / 2
        # puts "Player 1 wins #{partial}g."
        # @bank.payout(@players.first, @players.first.hands.size)
        # puts "Player 2 wins #{partial}g."
        # @bank.payout(@players.last, @players.last.hands.size)
      when -1
        winnings = @bank.payout(@players.last)
        puts "Player 2 wins! #{@players.last.name} wins #{winnings}g with #{@players.last.hands.hands_not_busted} hands."
      end

      # <<<<<<<<<<<<<<
      # Try auto-play_again
      # self.play_again
      # instead of
      # self.play_again?

    end

    def reset_game
      @players.each do |player|
        player.bet = 0
        player.reset
      end
    end

    def play_again?
      puts "\n\nPlay again?"
      continue = gets.chomp
      if ['n', 'no', 'N', 'No', 'NO'].include? continue
        self.winning_score
        exit
      elsif ['y', 'yes', 'Y', 'Yes', ''].include? continue
        self.reset_game
        self.play_again
      end
    end

    def play_again
      system 'clear'
      self.reset_game
      top_margin
      puts <<-PARAGRAPH
      New Round:


        + Shuffling deck
        + Resetting bets
        + Dealing cards


      Press [Enter] to continue.
      PARAGRAPH
      continue = gets.chomp
      @deck = self.make_deck
      self.play
    end
  end

  private
  attr_accessor :secret_bank
end

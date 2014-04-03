require 'observer'

class BlackJackDoubles

  include Observable
  attr_reader :deck, :players, :winner, :names, :bank, :hand_objects

  MINIMUM_BET = 20

  def initialize(names=nil)

    players = Array.new
    if names.nil?
      names = get_names
    elsif (!names.nil? && names.is_a?(Array) && names.length == 2)
      names = names
    elsif (!names.nil? && names.is_a?(Array) && names.length != 2)
      # Wrong number of players exception #unfinished
      puts "Wrong number of players"
      names = get_names
    elsif (!names.nil? && !names.is_a?(Array))
      names = get_names(names)
    else
      puts "Something failing in name initialization"
    end
    names.each do |name|
      players << Player.new(name)
    end

    @players = players
    @deck = self.make_deck
    @winner = nil
    @bank = Bank.new

    # Removing this line for testing purposes #unfinished
    # unless read_instructions? == false
    #   self.read_instructions
    # end
    @hand_objects = get_hand_objects
  end

  def make_deck
    Deck.new
  end

  def get_names(names=nil) # Returns an array of both names
       # Don't ask for names unless names is nil
    unless names != nil
      puts "\nWhat are your names, contestants?"
      names ||= gets.chomp
    end

    if names.is_a?(String) && names.include?(' ')
      names = names.split(' ')
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

  def get_hand_objects
    objects = {}
    @players.each do |player|
      objects[player.name] = nil
      player.hands.collection.each do |hand|
        if objects[player.name] == nil
          objects[player.name] = [hand.object_id]
        else
          objects[player.name] += [hand.object_id]
        end
      end
    end
    objects
  end


  def deal
    # This method deals with initial deal
    @players.each do |player|
      cards = @deck.serve(2)
      # Find if cards are of the same number
      if cards.first.number == cards.last.number
        # If they are, distribute card 1 to first hand and card 2 to second
        player.hands.collection.first.draw(cards.first)
        player.hands.new(cards.last)
      else
      # The player will only use their first hand in initial deal
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
    hand.pretty_print
    unless hand.stand? == true
      case
      when (hand.points > 21 && hand.has_ace?)
        puts "#{player.name}, you have over 21 points in this hand: #{hand.points} points"
        puts "Reducing your ace to equal 1 points instead of 11 points."
        hand.reduce_ace
        puts "After reducing value of the ace, you have #{hand.points} points."
        self.hit?(player, hand)
      when (hand.points > 21 && hand.has_ace? == false)
        puts "#{player.name}, your hand is bust: #{hand.points} points."
        hand.declare_bust(true)
      when hand.points < 21

        puts "\nYou have #{hand.points} points in this hand. \nYou can [h]it or [s]tand."
        #unfinished

        input = gets.chomp
        if 'h'.include? input
          self.hit(player, hand)
          hand.stand?(stand=false)
          self.hit?(player, hand)
        elsif 's'.include? input
          hand.stand?(stand=true)
          #unfinished method, #goto next player
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

    BlackJackDoubles is a spinoff of the popular card game BlBlackJackDoubles.
    It requires two players to play, and a neutral dealer.

    When starting the game, both players set an initial bet.
    They are then dealt two cards each, face up, so that both
    may see the other player's hand. A hand is any collection of cards.
    Like BlBlackJackDoubles, you win if you score 21 points, or if you have a
    higher score than the other player's corresponding hand while staying
    under 21. You may have as many hands as you'd like.

    However, when you split a hand, your bet automatically doubles.
    At the end of the game, whether you stop betting or you run out of cards,
    your hands will be compared to your opponent's hands, the best against the
    best, and the winner will receive the prize money.
    You'll both start out with 1000g, and the minimum bet is 20g. Good luck!


    * Press [Enter] to continue *
    PARAGRAPH
    STDIN.gets

  end

  def play
    gameplay_intro
    gameplay_logic
  end

  def bet
    #1) Initial bet
    @players.each do |player|
      puts <<-PARAGRAPH
      #{player.name},
      The minimum bet is 20g. You have #{player.purse.balance}g.
      Press [Enter] to bet the minimum 20g, or [b] to change your bet.

      PARAGRAPH
      input = gets.chomp
      if ['b', 'bet'].include? input
        puts "Hotshot, eh? Enter your bet:"
        wager = gets.chomp
        wager = wager.to_i
        while wager < MINIMUM_BET
          puts "20g is the minimum bet. Enter your bet:"
          wager = gets.chomp.to_i
        end
        player.bet = wager
        player.purse.subtract_bet(wager)
        @bank.deposit(wager)
      elsif ["", nil].include? input
        wager = MINIMUM_BET
        player.bet = wager
        player.purse.subtract_bet(wager)
        @bank.deposit(wager)
      else
        puts "Sorry, I didn't understand that."
        system 'clear'
        self.bet
      end
    end
  end

  def scoreboard(player=nil)
    graphics = BlackJackDoublesGraphics.new
    if player == nil
      @players.each do |player|
        graphics.print_grid(player.hands)
        puts "\n#{player.name} has the following scores for each hand: "
        player.hands.collection.each_with_index do |hand, index|
          puts "Hand #{index + 1} has a score of #{hand.points} points."
        end
      end
    else
      graphics.print_grid(player.hands)
      puts "\n#{player.name} has the following scores for each hand: "
      player.hands.collection.each_with_index do |hand, index|
        puts "Hand #{index + 1} has a score of #{hand.points} points."
      end
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
    puts "This is a spinoff of BlBlackJackDoubles where you split when you're dealt a repeat number and the player with the best set of hands wins."
    unless self.read_instructions? == false
      self.read_instructions
    end

    # Verify both players have made a bet
    system 'clear'
    self.bet

    # After both players have bet, deal then print current state of affairs
    self.deal
    system 'clear'
    self.scoreboard

    puts "\n\nPress [Enter] key to continue... "
    continue = gets.chomp
  end

  def gameplay_logic
    # Implement game, certainly could be broken down better. Hackety hack etc.

    @players.each do |player|
      system 'clear'
      puts "\nIt is now #{player.name}'s turn."
      puts "Press [Enter] to continue... "
      continue = gets.chomp
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


    # Step 4: Prompt each player to hit or stand per hand
    # def gameplay_hit
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

      if player == @players.first
        puts "Press [Enter] before #{@players.last.name} begins."
        continue = gets.chomp
      end
      # By default, if the player hits, the card received is a duplicate
      # value of another in the hand, split hands provided the player can afford to double
      # his or her bet
      # Create watcher here #unfinished


    end


    # Step 6: Announce gameplay to have ended and sum scores
      #winninglogic #unfinished
    puts "Gameplay has ended! Let's look at the scores."
    self.winning_score
    # Implement scoring of all hands
    # End @players.each loop
    nil
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
      result = (@players.first.hands.collection[x].points <=> self.players.last.hands.collection[x].points)
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
      when name[i] == @players.first.name
        hands[i+1].insert(player.hands[i].points)
      when name[i] == @players.last.name
        hands[i+1].insert(player.hands[i].points)
      end
    }
    hands
  end



  # Next to implement: Game/Scoring Logic, Winning Logic, Watchers for game winner
  # Errors/Exceptions


end

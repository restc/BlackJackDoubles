
class AckJack
  
  attr_reader :deck, :players, :winner, :game, :names, :bank

  MINIMUM_BET = 20

  def initialize(names=nil)

    players = Array.new

    if names.nil?
      @names = get_names
    elsif !names.nil? && names.is_a?(Array) && names.length == 2 
      @names = names
    elsif !names.nil? && names.is_a?(Array) && names.length != 2
      # Wrong number of players exception #unfinished
      puts "Wrong number of players"
      @names = get_names
    elsif !names.nil? && !names.is_a?(Array)
      @names = get_names(names)
    else
      puts "Something failing in name initialization"
    end
    @names.each do |name|
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

  end


  def make_deck
    Deck.new
  end

  def get_names(names=nil) # Returns an array of both names
    names ||= gets.chomp   # Don't ask for names unless names is nil
    unless names != nil   
      puts "\nWhat are your names, humble opponents?"
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
    return names
  end

  def get_score player
    player.hand.score
  end

  def deal
    # This method deals with initial deal
    @players.each do |player|
      cards = @deck.deck.shift(2)
      player.hand.draw(cards)
    end
  end

  def hit player
    # This method is used when a player wants an additional card
    unless player.stand == true
      card = @deck.deck.shift(1)
      player.hand.draw(card)
    end
  end

  def hit?
    puts "You can [h]it or [s]tand."
    puts "If you'd like to split hands..."
    input = gets.chomp
    if 'h'.include? input
      hit self
      self.stand(stand=false)
      #unfinished method - #goto hit again
    elsif 's'.include? input
      self.stand?(stand=true)
      #unfinished method, #goto next player
    else
      puts "Please use h if you want another card, or type s if you'd like to stand."
      self.hit?
    end
  end

  def read_instructions?
    puts "Would you like an explanation of how to play?"
    input = gets.chomp
    if ['y', 'yes'].include? input.downcase
      true
    else
      false #unfinished
    end
  end

  def read_instructions
    system 'clear'
    puts <<-PARAGRAPH

    AckJack is a spinoff of the popular card game Blackjack.
    It requires two players to play, and a neutral dealer.

    When starting the game, both players set an initial bet.
    They are then dealt two cards each, face up, so that both 
    may see the other player's hand. A hand is any collection of cards. 
    To win a hand, the sum of the cards must be equal to 21, or 
    higher than the other player's hand, not exceeding 21. 
    You may have as many hands as you'd like. 
    You can split a hand whenever you'd like.
    
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
    self.deal
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
        unless wager >= MINIMUM_BET
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

  def scoreboard
    graphics = AckJackGraphics.new
    @players.each do |player|
      graphics.print_grid(player.hands)
      puts "\n#{player.name} has a score of #{player.score}" 
    end

  end



  def gameplay_logic
    # In order to specify each player
    player1 = @players.first
    player2 = @players.last

    # Step 1: Verify both players have made a bet
    self.bet

    # Step 2: After both players have bet, print current state of affairs
    self.scoreboard

    # Step 3: Allow each player to double the bet before choosing to hit or stand


    # Step 4: Prompt each player to hit or stand
    #self.hit?

      # Step 4.5: If any player wants to split hands, implement that here


    # Step 5: Check both players' :stand status looking for true

      
    # Step 6: Announce gameplay to have ended and sum scores
      #winninglogic #unfinished



  end






  # Next to implement: Game/Scoring Logic, Winning Logic, Watchers for game winner
  # Errors/Exceptions


end










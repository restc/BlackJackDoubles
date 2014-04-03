BlackJack Doubles
=================

BlackJack Doubles is an alternative ruleset for BlackJack in which you and one other person compete to see who has the best set of hands. When you are dealt a duplicate number, your hand will split into two and your bet will double.

To instantiate the game, call `BlackJackDoubles.new`. Optionally pass in a string with the two players' names. Then call `play` on the game instance to start.

    game = BlackJackDoubles.new 'Tom Jerry'
    game.play

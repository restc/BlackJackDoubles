project_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(project_root + '/Classes/*', &method(:require))

game = BlackJackDoubles.new
game.play

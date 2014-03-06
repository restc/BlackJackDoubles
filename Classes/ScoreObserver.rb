# AckJack.rb
# observer methods

class Busted
  def twentyone(player)
    puts "ALERT: hit twenty one points."
  end
end

module ScoreObserver
  attr_reader :observers

  def initialize
    @observers = []
  end

  def add_observer(*observers)
    observers.each {|observer| @observers << observer }
  end

  def delete_observer(*observers)
    observers.each {|observer| @observers << observer }
  end

  private
  def notify_observers
    observers.each {|observer| observer.twentyone(self)}
  end
end
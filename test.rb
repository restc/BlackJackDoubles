require 'observer'

class Notifier
  def update
    puts "The car has logged #{miles} miles, totaling #{car.mileage} miles traveled."
    puts "The car needs to be taken in for a service!" if car.service <= car.mileage
  end
end

class Car
  include Observable
  attr_reader :mileage, :service

  def initialize(mileage = 0, service = 3000)
    @mileage, @service = mileage, service
    add_observer(Notifier.new)
  end

  def log(miles)
    @mileage += miles
    changed
    notify_observers(self, miles)
  end
end


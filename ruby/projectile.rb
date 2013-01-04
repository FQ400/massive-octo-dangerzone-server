require_relative 'game_object'

class Projectile < GameObject
  attr_accessor :speed
  attr_accessor :direction

  def initialize(id, icon, start_position, direction, speed)
    super(id, icon, start_position)
    @direction = direction
    @speed = speed
  end
end

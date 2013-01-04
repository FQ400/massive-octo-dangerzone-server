require_relative 'game_object'

class Projectile < GameObject
  attr_accessor :speed
  attr_accessor :direction

  def initialize(id, icon, start_position, direction, speed, ttl, range)
    super(id, icon, start_position, ttl, range)
    @direction = direction
    @speed = speed
  end
end

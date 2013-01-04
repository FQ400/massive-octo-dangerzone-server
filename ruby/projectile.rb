require_relative 'game_object'

class Projectile < GameObject
  attr_accessor :speed
  attr_accessor :direction
  attr_accessor :size

  def initialize(id, icon, start_position, direction, speed, ttl, range)
    super(id, icon, start_position, ttl, range)
    @direction = direction
    @speed = speed
    @icon = 'http://www.cascadianfarm.com/img/home/Like_thumb.gif'
    @size = -1
  end
end

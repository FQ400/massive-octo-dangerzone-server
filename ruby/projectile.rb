require_relative 'game_object'

class Projectile < GameObject

  def initialize(icon, start_position, direction, size, speed, ttl, range)
    super(icon, start_position, size, speed, ttl, range)
    @direction = direction
    @icon = 'http://www.cascadianfarm.com/img/home/Like_thumb.gif'
    @size = -1
  end
end

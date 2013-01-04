require 'matrix'

class GameObject
  attr_accessor :id
  attr_accessor :icon
  attr_accessor :position
  attr_accessor :direction
  attr_accessor :angle

  def initialize(id, icon, position=Vector[0, 0], ttl=-1, range=300)
    @id = id
    @icon = icon
    @position = @start_position = position
    @ttl = ttl
    @spawn_time = Time.now.to_f
    @range = range
    @direction = Vector[0, 0]
    @angle = 0
  end

  def alive?
    (@ttl < 0 or (Time.now.to_f - @spawn_time) < @ttl) and (@range < 0 or (@start_position - @position).norm < @range)
  end
end

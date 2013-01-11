class GameObject
  attr_accessor :id, :icon, :position, :direction, :angle, :speed, :direction, :size, :owner

  def initialize(icon, position=Vector[0, 0], size=60, speed=100, ttl=-1, range=300)
    @id = rand(10000000)
    @icon = icon
    @position = @start_position = position
    @size = 60
    @speed = speed
    @ttl = ttl
    @spawn_time = Time.now.to_f
    @range = range
    @direction = Vector[0, 0]
    @angle = 0
    @killed = false
    @hp = 10000
  end

  def alive?
    (not @killed) and
    (@ttl < 0 or (Time.now.to_f - @spawn_time) < @ttl) and
    (@range < 0 or (@start_position - @position).norm < @range)
  end

  def kill
    @killed = true
  end

  def hashify
    {
      id: @id,
      icon: @icon,
      position: @position,
      size: @size,
      angle: @angle
    }
  end
end

class GameObject
  attr_accessor :id, :icon, :position, :direction, :angle, :speed, :direction, :size, :owner, :hp

  def initialize(options)
    options = {
      angle: 0,
      direction: Vector[0,0],
      hp: 10000,
      icon: nil,
      killed: false,
      position: Vector[0,0],
      range: 300,
      size: 60,
      speed: 100,
      ttl: -1
    }.merge(options)
    
    options.each do |key, value|
      instance_variable_set("@#{key.to_s}", value)
    end
    
    @id = rand(10000000)
    @start_position = @position 
    @spawn_time = Time.now.to_f
    
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
      position: @position.to_a,
      size: @size,
      angle: @angle,
      hp: @hp
    }
  end
end

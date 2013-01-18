class GameObject
  attr_accessor :id, :icon, :position, :direction, :angle, :speed, :direction, :size, :hp, :visible, :effects

  def initialize(options)
    options = {
      angle: 0,
      direction: Vector[0,0],
      icon: nil,
      killed: false,
      position: Vector[0,0],
      range: 300,
      size: 60,
      speed: 100,
      ttl: -1,
      visible: true
    }.merge(options)
    
    options.each do |key, value|
      instance_variable_set("@#{key.to_s}", value)
    end
    
    @id = rand(10000000)
    @start_position = @position 
    @spawn_time = Time.now.to_f
    @effects = {}
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
      hp: @hp,
      visible: @visible
    }
  end

  def speed
    apply_effects('speed')
  end

  def apply_effects(attr)
    value = instance_variable_get(('@' + attr).to_sym)
    return value if @effects[attr.to_sym].nil?
    @effects[attr.to_sym].each do |effect|
      value = effect.apply(value)
    end
    value
  end

end

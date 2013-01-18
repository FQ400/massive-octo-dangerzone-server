class GameObject
  attr_accessor :id, :effects

  def initialize(options)
    @options = {
      angle: 0,
      position: Vector[0,0],
      direction: Vector[0,0],
      hp: 10000,
      icon: nil,
      killed: false,
      position: Vector[0,0],
      range: 300,
      size: 60,
      speed: 100,
      ttl: -1,
      visible: true
    }.merge(options)

    @id = rand(10000000)
    @start_position = @options[:position] 
    @spawn_time = Time.now.to_f
    @effects = {}
  end

  def alive?
    (not @killed) and
    (ttl < 0 or (Time.now.to_f - @spawn_time) < ttl) and
    (range < 0 or (@start_position - position).norm < range)
  end

  def kill
    @killed = true
  end

  def hashify
    {
      id: id,
      icon: icon,
      position: position.to_a,
      size: size,
      angle: angle,
      hp: hp,
      visible: visible
    }
  end

  # TODO respond_to anpassen
  def method_missing(name, *args, &block)
    orig_name = name
    if name[-1] == '='
      name = name[0..-2]
    end
    if @options.has_key?(name.to_sym)
      args.count > 0 ? @options[name.to_sym] = args[0] : apply_effects(name.to_sym)
    else
      puts name
      puts args
      puts @options
      super(orig_name, *args, block)
    end
  end

  def apply_effects(attr)
    value = @options[attr]
    return value if @effects[attr].nil?
    @effects[attr].each do |effect|
      value = effect.apply(value)
    end
    value
  end

end

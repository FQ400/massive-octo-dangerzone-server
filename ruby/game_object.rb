class GameObject
  attr_accessor :id, :effects

  def initialize(options)
    @options = {
      angle: 0,
      position: Vector[0,0],
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
    @id = rand(10000000)
    @start_position = @options[:position] 
    @spawn_time = Time.now.to_f
    @effects = {}
  end

  def alive?
    (not self[:killed]) and
    (self[:ttl] < 0 or (Time.now.to_f - @spawn_time) < self[:ttl]) and
    (self[:range] < 0 or (@start_position - self[:position]).norm < self[:range])
  end

  def kill
    self[:killed] = true
  end

  def hashify
    {
      id: @id,
      icon: self[:icon],
      position: self[:position].to_a,
      size: self[:size],
      angle: self[:angle],
      hp: self[:hp],
      visible: self[:visible]
    }
  end

  # TODO respond_to anpassen
  def method_missing(name, *args, &block)
    orig_name = name
    name = name.to_s
    name = name[0..-2] if name[-1] == '='
    if @options.has_key?(name.to_sym)
      args.count > 0 ? @options[name.to_sym] = args[0] : apply_effects(name.to_sym)
    else
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

  def [](key)
    apply_effects(key.to_sym)
  end

  def []=(key, value)
    @options[key] = value
  end

  def add_effect(effect)
    @effects[effect.type] ||= []
    @effects[effect.type].push(effect)
  end

  def remove_effect(effect)
    @effects[effect.type].delete(effect)
  end
end

class Shrinker < Pickup

  def initialize(options)
    raise NoConfigException.new if GameConfig::PICKUPS[self.class.to_sym].nil?
    options = GameConfig::PICKUPS[self.class.to_sym].merge(options)
    super(options)
  end
  
  def apply(user)
    user.add_effect(ShrinkEffect.new(user))
    kill
  end
end

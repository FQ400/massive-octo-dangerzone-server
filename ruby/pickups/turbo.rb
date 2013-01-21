class Turbo < Pickup

  def initialize(options={})
    raise NoConfigException.new if GameConfig::PICKUPS[self.class.to_sym].nil?
    options = GameConfig::PICKUPS[self.class.to_sym].merge(options)
    super(options)
  end

  def apply(user)
    user.add_effect(TurboEffect.new(user, {}))
    kill
  end
end

class NoConfigException < Exception
  def message
    "No configuration in App::GameConfig::PICKUPS found. Please add one."
  end
end
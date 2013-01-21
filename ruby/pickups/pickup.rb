class Pickup < GameObject

  def initialize(options)
    raise NoConfigException.new if GameConfig::PICKUPS[self.class.to_sym].nil?
    options = GameConfig::PICKUPS[self.class.to_sym].merge(options)
    super(options)
  end

end

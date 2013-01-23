class NoConfigException < Exception
  def initialize(name)
    @name = name
    super
  end

  def message
    "No configuration in App::GameConfig::PICKUPS found for #{@name}. Please add one."
  end
end

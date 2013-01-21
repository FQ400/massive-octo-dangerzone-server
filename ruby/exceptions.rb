class NoConfigException < Exception
  def message
    "No configuration in App::GameConfig::PICKUPS found. Please add one."
  end
end

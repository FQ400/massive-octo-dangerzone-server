class Effect < GameObject

  attr_reader :target

  @@active_effects = []

  def initialize(target)
    super(visible: false)
    @target = target
    @@active_effects.push(self)
  end

end

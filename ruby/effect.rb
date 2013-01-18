class Effect < GameObject

  attr_reader :target

  @@active_effects = []

  def initialize(target)
    super('', Vector[0, 0], Vector[0, 0], 0, 0, -1, -1, false)
    @target = target
    @@active_effects.push(self)
  end

end

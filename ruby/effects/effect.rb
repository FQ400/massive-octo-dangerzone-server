class Effect < GameObject

  attr_reader :target

  def initialize(target, options={})
    super(options)
    @target = target
  end

  def apply(user, type)
    unless alive?
      @target.remove_effect(self)
    end
  end
end

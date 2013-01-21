class Effect < GameObject

  attr_reader :target

  def initialize(target, options)
    options = {
      visible: false,
      type: nil
      }.merge(options)
    super(options)
    @target = target
  end

  def apply(user)
    unless alive?
      @target.remove_effect(self)
    end
  end
end

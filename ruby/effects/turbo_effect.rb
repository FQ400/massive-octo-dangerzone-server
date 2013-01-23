class TurboEffect < Effect

  def initialize(target, options={})
    super(target, options)
  end

  def apply(speed, type)
    super
    speed * 3.0
  end
end

class TurboEffect < Effect

  def initialize(target, options)
    options = {
      ttl: 3,
      type: :speed
      }.merge(options)
    super(target, options)
  end

  def apply(speed)
    super
    speed * 3.0
  end
end

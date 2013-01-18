class ShrinkEffect < Effect

  def initialize(target, options={})
    options = {
      ttl: 3,
      type: :size
      }.merge(options)
    super(target, options)
  end

  def apply(size)
    super
    size / 3
  end
end

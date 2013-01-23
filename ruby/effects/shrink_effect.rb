class ShrinkEffect < Effect

  def initialize(target, options={})
    super(target, options)
  end

  def apply(size, type)
    super
    size / 3
  end
end

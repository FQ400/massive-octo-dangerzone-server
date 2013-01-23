class DeathEffect < Effect

  def initialize(target, options={})
    super(target, options)
  end

  def apply(size, type)
    super
    false
  end
end

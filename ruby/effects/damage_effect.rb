class DamageEffect < Effect

  def apply(hp, type)
    super
    hp - 20
  end

end

class WheelDamageEffect < Effect

  def apply(value, type)
    super
    case type
      when :speed then value - 20
      when :hp then value - 10
    end
  end
end

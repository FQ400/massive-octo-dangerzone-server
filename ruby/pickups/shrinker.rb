class Shrinker < Pickup

  def apply(user)
    user.add_effect(ShrinkEffect.new(user))
    kill
  end

end

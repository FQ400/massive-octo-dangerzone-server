class Cloak < Pickup

  def apply(user)
    user.add_effect(InvisibilityEffect.new(user))
    kill
  end

end

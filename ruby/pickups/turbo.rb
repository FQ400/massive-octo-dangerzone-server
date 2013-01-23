class Turbo < Pickup

  def apply(user)
    user.add_effect(TurboEffect.new(user, {}))
    kill
  end

end

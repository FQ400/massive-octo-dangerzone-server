class Projectile < GameObject

  def initialize(owner, options={})
    super(options)
    @owner = owner
  end

  def apply(user)
    return if user == @owner
    user.add_effect(WheelDamageEffect.new(user))
    kill
  end
end

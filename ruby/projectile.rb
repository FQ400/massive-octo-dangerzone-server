class Projectile < GameObject

  DAMAGES = [DamageEffect, WheelDamageEffect]

  def initialize(owner, options={})
    super(options)
    @owner = owner
  end

  def apply(user)
    return if user == @owner
    index = rand(DAMAGES.count)
    user.add_effect(DAMAGES[index].new(user))
    kill
  end
end

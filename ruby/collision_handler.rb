class CollisionHandler

  def initialize(scene)
    @scene = scene
  end

  def detect
    (@scene.users + @scene.objects).combination(2).select do |pair|
      collide?(pair[0], pair[1])
    end
  end

  def collide?(object1, object2)
    (object1.position - object2.position).norm() < ((object1.size + object2.size) / 2)
  end

  def handle(collision)
    object1, object2 = collision[0], collision[1]
    # puts 'collision:'
    if object1.is_a?(User)
      handle_user(object1, object2)
    elsif object2.is_a?(User)
      handle_user(object2, object1)
    else
      handle_objects(object1, object2)
    end
  end

  def handle_user(user, object)
    if object.is_a?(User)
      handle_users(user, object)
    else
      handle_user_object(user, object)
    end
  end

  def handle_users(user1, user2)
    puts 'users'
  end

  def handle_objects(object1, object2)
    if object1.is_a?(Projectile) and not object2.is_a?(Projectile)
      object2.kill
    elsif object2.is_a?(Projectile) and not object1.is_a?(Projectile)
      object1.kill
    end
  end

  def handle_user_object(user, object)
    return if user == object.owner
    if object.is_a?(Pickup)
      object.apply(user)
      object.kill
    end
  end
end

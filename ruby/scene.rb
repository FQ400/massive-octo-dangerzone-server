class Scene
  attr_accessor :users
  attr_accessor :objects

  def initialize
    @users = []
    @objects = []
    @last_update = Time.now.to_f
  end

  def remove_dead
    deleted = @objects.select { |object| not object.alive? }
    @objects -= deleted
    deleted
  end

  def move_users
    @users.each do |user|
      user.update_angle
      user.direction = user.rotation_matrix * user.move_direction
    end
  end

  def move_objects
    now = Time.now.to_f
    time_since_last = now - @last_update
    @last_update = now
    (@objects + @users).each do |object|
      diff = object.direction * object.speed * time_since_last
      move_object(object, diff)
    end
  end

  def move_object(user, diff)
    user.position += diff
  end
end

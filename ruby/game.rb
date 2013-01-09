require 'eventmachine'
require 'matrix'

require_relative 'projectile'

class Game

  def initialize(app)
    @channel = EventMachine::Channel.new
    @users = []
    @objects = []
    @app = app
    @start_positions = [[540, 100], [100, 380], [540, 380], [100, 100]]
    @last_update = Time.now.to_f
  end

  def join(user)
    return if @users.include?(user)
    @users.push(user)
    @app.chat_all("User '#{user.name}' joined the game")
    init_user(user)
    msg = {:type => :game, :subtype => :init, :id => user.id}.to_json
    user.socket.send(msg)
  end

  def leave(user)
    return unless @users.include?(user)
    @start_positions.push(user.start_position.to_a)
    user.unsubscribe(@channel, :game)
    @users.delete(user)
    @app.chat_all("User '#{user.name}' left the game")
    objects = [{:id => user.id}]
    msg = {:type => :game, :subtype => :objects_deleted, :objects => objects}.to_json
    @channel.push(msg)
  end

  def init_user(user)
    user.init_position(@start_positions.pop)
    objects = [user]
    update_object_list(objects, nil)
    user.subscribe(@channel, :game)
    objects = (@users + @objects).collect { |o| {:id => o.id, :icon => o.icon, :position => o.position, :size => o.size} }
    msg = {:type => :game, :subtype => :objects_created, :objects => objects}.to_json
    user.socket.send(msg)
  end

  def update_object_list(created=nil, deleted=nil)
    if created
      objects = created.collect { |o| {:id => o.id, :icon => o.icon, :position => o.position, :size => o.size} }
      msg = {:type => :game, :subtype => :objects_created, :objects => objects}.to_json
      @channel.push(msg)
    end
    if deleted
      objects = deleted.collect { |o| {:id => o.id} }
      msg = {:type => :game, :subtype => :objects_deleted, :objects => objects}.to_json
      @channel.push(msg)
    end
  end

  def update_objects
    now = Time.now.to_f
    time_since_last = now - @last_update
    move_scale = time_since_last
    @last_update = now
    @users.each do |user|
      user.direction = user.rotation_matrix * user.move_direction
    end
    deleted = @objects.select { |object| not object.alive? }
    @objects -= deleted
    (@objects + @users).each do |object|
      diff = object.direction * object.speed * move_scale
      move_object(object, diff)
    end
    update_object_list(nil, deleted) unless deleted.empty?
  end

  def move_object(user, diff)
    user.position += Vector.elements(diff)
  end

  def rotate_user(user, angle)
    user.angle = -angle
  end

  def user_angle
    (@objects + @users).collect { |o| {:id => o.id, :angle => o.angle} }
  end

  def object_pos
    (@objects + @users).collect { |o| {:id => o.id, :position => o.position.to_a} }
  end

  def shoot(user, position)
    id = rand(1000000)
    icon = ''
    direction = (Vector.elements(position) - Vector.elements(user.position)).normalize()
    object = Projectile.new(id, icon, user.position, direction, 3, 300, 100, 300)
    object.angle = user.angle
    @objects.push(object)
    update_object_list([object], nil)
  end
end

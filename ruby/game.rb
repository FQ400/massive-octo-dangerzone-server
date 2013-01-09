require 'eventmachine'
require 'matrix'

require_relative 'projectile'
require_relative 'pickup'
require_relative 'shrinker'
require_relative 'scene'
require_relative 'collision_handler'

class Game

  def initialize(app)
    @channel = EventMachine::Channel.new
    @scene = Scene.new
    @app = app
    @start_positions = [[540, 100], [100, 380], [540, 380], [100, 100]]
    init_objects()
    @collision_handler = CollisionHandler.new(self, @scene)
  end

  def init_objects
    objects = [
      Pickup.new('', Vector[200, 200], Vector[0, 0], 3, 300, -1, -1), 
      Pickup.new('', Vector[500, 150], Vector[0, 0], 3, 300, -1, -1),
      Shrinker.new('', Vector[400, 300], Vector[0, 0], 3, 300, -1, -1),
    ]
    @scene.objects += objects
    update_object_list(created: objects)
  end

  def join(user)
    return if @scene.users.include?(user)
    @scene.users.push(user)
    @app.chat_all("User '#{user.name}' joined the game")
    init_user(user)
    msg = {:type => :game, :subtype => :init, :id => user.id}.to_json
    user.socket.send(msg)
  end

  def leave(user)
    return unless @scene.users.include?(user)
    @start_positions.push(user.start_position.to_a)
    user.unsubscribe(@channel, :game)
    @scene.users.delete(user)
    @app.chat_all("User '#{user.name}' left the game")
    objects = [{:id => user.id}]
    msg = {:type => :game, :subtype => :objects_deleted, :objects => objects}.to_json
    @channel.push(msg)
  end

  def init_user(user)
    user.init_position(@start_positions.pop)
    objects = [user]
    update_object_list(created: objects)
    user.subscribe(@channel, :game)
    objects = (@scene.users + @scene.objects).collect { |o| o.hashify }
    msg = {:type => :game, :subtype => :objects_created, :objects => objects}.to_json
    user.socket.send(msg)
  end

  # def update_object_list(created=nil, deleted=nil)
  def update_object_list(args)
    created = args[:created]
    deleted = args[:deleted]
    if created
      objects = created.collect { |o| o.hashify }
      msg = {:type => :game, :subtype => :objects_created, :objects => objects}.to_json
      @channel.push(msg)
    end
    if deleted
      objects = deleted.collect { |o| o.hashify.only(:id) }
      msg = {:type => :game, :subtype => :objects_deleted, :objects => objects}.to_json
      @channel.push(msg)
    end

  end

  def update_objects
    @scene.move_users
    deleted = @scene.remove_dead
    @scene.move_objects
    update_object_list(deleted: deleted) unless deleted.empty?
    collisions = @collision_handler.detect
    collisions.each do |collision|
      @collision_handler.handle(collision)
    end
  end

  def rotate_user(user, angle)
    user.angle = -angle
  end

  def object_angle
    (@scene.objects + @scene.users).collect { |o| o.hashify.only(:id, :angle) }
  end

  def object_size
    (@scene.objects + @scene.users).collect { |o| o.hashify.only(:id, :size) }
  end

  def object_pos
    (@scene.objects + @scene.users).collect { |o| {:id => o.id, :position => o.position.to_a} }
    #(@scene.objects + @scene.users).collect { |o| o.hashify.only(:id, :position) }
  end

  def shoot(user, position)
    icon = ''
    direction = (Vector.elements(position) - Vector.elements(user.position)).normalize()
    object = Projectile.new(icon, user.position, direction, user, 3, 300, 100, 900)
    object.angle = user.angle
    @scene.objects.push(object)
    update_object_list(created: [object])
  end
end

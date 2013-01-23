class Game
  
  attr_reader :channel

  def initialize(app)
    @channel = EventMachine::Channel.new
    @scene = Scene.new
    @app = app
    @start_positions = [[540, 100], [100, 380], [540, 380], [100, 100]]
    init_objects()
    @collision_handler = CollisionHandler.new(@scene)
  end

  def init_objects
    objects = [
      Turbo.new({
        position: Vector[200, 200]
      }),
      Cloak.new({
        position: Vector[500, 150]
      }),
      Shrinker.new({
        position: Vector[400, 300]
      }),
    ]
    @scene.objects += objects
    update_object_list(created: objects)
  end

  def join(user)
    return if @scene.users.include?(user)
    @scene.users.push(user)
    msg = ChatMessage.new(body: "User '#{user.name}' joined the game")
    @app.chat.send(msg)
    init_user(user)
    msg = {:type => :game, :subtype => :init, :id => user.id}.to_json
    user.socket.send(msg)
  end

  def leave(user)
    return unless @scene.users.include?(user)
    @start_positions.push(user.start_position.to_a)
    user.unsubscribe(@channel, :game)
    @scene.users.delete(user)

    msg = ChatMessage.new(body: "User '#{user.name}' joined the game")
    @app.chat.send(msg)

    objects = [{:id => user.id}]
    msg = {:type => :game, :subtype => :objects_deleted, :objects => objects}.to_json
    @channel.push(msg)
  end

  def init_user(user)
    user.init_position(@start_positions.pop)
    objects = [user]
    update_object_list(created: objects)
    user.subscribe(@channel, :game)
    msg = complete_info_msg(@scene.all)
    user.socket.send(msg)
  end

  def update_object_list(args)
    created = args[:created]
    deleted = args[:deleted]
    msgs = []
    msgs.push(complete_info_msg(created)) if created
    msgs.push(id_info_msg(deleted)) if deleted
    msgs.each { |msg| @channel.push(msg) }
  end

  def complete_info_msg(objects, subtype=:objects_created)
    object_info_msg(objects, subtype) { |o| o.hashify }
  end

  def id_info_msg(objects, subtype=:objects_deleted)
    object_info_msg(objects, subtype) { |o| o.hashify.only(:id) }
  end

  def object_info_msg(objects, subtype, &block)
    objects = objects.select { |o| o.visible }.collect { |o| block.call(o) }
    {:type => :game, :subtype => subtype, :objects => objects}.to_json
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

  def push_object_info
    msg = complete_info_msg(@scene.all, :state)
    @channel.push(msg)
  end

  def shoot(user, position)
    icon = ''
    # speed = user.speed * (direction * user.rotation_matrix * user.move_direction)
    object = Projectile.new(user, {
      position: user.position.clone,
      direction: (position.to_v - user.position).normalize(),
      angle: user.angle
    })
    @scene.objects.push(object)
    update_object_list(created: [object])
  end
end

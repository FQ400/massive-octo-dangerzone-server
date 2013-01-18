class User < GameObject
  attr_accessor :name, :socket, :start_position, :key_states

  DIRECTIONS = ['left', 'up', 'right', 'down']

  def initialize(name, socket, options)
    options = {
      hp: 100,
      size: 60
      }.merge(options)
    super(options)
    @name = name
    @socket = socket
    @ids = {}
    @key_states = { left: 0, right: 0, up: 0, down: 0 }
    @focus = Vector[0, -1]
  end

  def subscribe(channel, name)
    @ids[name] = channel.subscribe { |msg| socket.send(msg) }
  end

  def unsubscribe(channel, name)
    return unless @ids.has_key?(name)
    channel.unsubscribe(@ids[name])
    @ids.delete(name)
  end

  def init_position(position)
    self[:position] = @start_position = position.to_v
  end

  def keypress_direction(direction, down)
    @key_states[direction.to_sym] = down
  end

  def rotation_matrix
    c, s = Math.cos(self[:angle]), Math.sin(self[:angle])
    Matrix[
      [c, -s],
      [s, c]
    ]
  end

  def move_direction
    Vector[
      (@key_states[:right] - @key_states[:left]),
      (@key_states[:down] - @key_states[:up])
    ]
  end

  def mouse_move(coords)
    @focus = coords.to_v
  end

  def update_angle
    new_angle = (self[:position] - @focus)
    self[:angle] = -Math.atan2(*new_angle.normalize()) if new_angle.norm() > 0
  end
end

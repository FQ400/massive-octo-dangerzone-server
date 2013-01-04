require 'matrix'

# make single elements assignable
class Vector
  def []=(i, x)
    @elements[i] = x
  end
end

class User
  attr_accessor :name
  attr_accessor :socket
  attr_accessor :icon
  attr_accessor :position
  attr_accessor :start_position
  attr_accessor :key_states

  DIRECTIONS = ['left', 'up', 'right', 'down']

  def initialize(name, socket, icon)
    @name = name
    @socket = socket
    @icon = icon
    @ids = {}
    @position = @start_position = Vector[0, 0]
    @key_states = Vector[0, 0, 0, 0]
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
    @position = @start_position = Vector.elements(position)
  end

  def keypress_direction(direction, down)
    @key_states[DIRECTIONS.index(direction)] = down
  end
end

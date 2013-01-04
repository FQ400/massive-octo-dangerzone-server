require 'eventmachine'
require 'em-websocket'

require_relative 'user'
require_relative 'game'

class App

  def initialize
    @users = {}
    @chat = EventMachine::Channel.new
    @game = Game.new(self)
    @update_running = false
    @random = Random.new(2)
  end

  def register(data, socket)
    name = data['name']
    remove_user(name)
    count = @users.count
    return if count >= 4
    id = @random.rand(1000000)
    user = User.new(id, name, socket, data['icon'])
    user.subscribe(@chat, :chat)
    @users[socket] = user
    chat_all("User '#{name}' signed on")
  end

  def remove_user(crit)
    user = find_user(crit)
    unless user.nil?
      @game.leave(user)
      user.unsubscribe(@chat, :chat)
      chat_all("User '#{user.name}' signed off")
      puts "removed #{user.name}"
      @users.delete user.socket
      msg = {:type => :user, :subtype => :deleted, :name => user.name}.to_json
      message_all(msg)
    end
  end

  def chat_all(_message, user=nil)
    user = find_user(user)
    _message = "|#{user.name}| #{_message}" unless user.nil?
    msg = {:type => :chat, :subtype => :new_message, :message => _message}.to_json
    @chat.push(msg)
  end

  def message_all(_message)
    @users.values.each do |user|
      message(user, _message)
    end
  end

  def message(user, _message)
    user.socket.send(_message)
  end

  def find_user(crit)
    if crit.kind_of?(EventMachine::WebSocket::Connection)
      @users.fetch(crit, nil)
    elsif crit.kind_of?(String)
      matches = @users.values.select { |u| u.name == crit }
      matches[0] if matches
    end
  end

  def chat_message(data, socket)
    case data['subtype']
    when 'public_message' then chat_all(data['data']['message'], socket)
    end
  end

  def game_message(data, socket)
    user = find_user(socket)
    return if user.nil?
    case data['subtype']
    when 'join' then @game.join(user)
    when 'leave' then @game.leave(user)
    when 'keydown' then key(user, data['data'], 1)
    when 'keyup' then key(user, data['data'], 0)
    when 'shoot' then @game.shoot(user, data['data'])
    when 'rotate' then @game.rotate_user(user, data['data'])
    end
  end

  def key(user, key, down)
    if User::DIRECTIONS.include?(key)
      user.keypress_direction(key, down)
    end
  end

  def ping
    return if @update_running
    @update_running = true
    @game.update_objects
    positions = @game.object_pos
    angles = @game.user_angle 
    msg = {:type => 'game', :subtype => 'state', :positions => positions, :angles => angles }.to_json
    message_all(msg)
    @update_running = false
  end
end

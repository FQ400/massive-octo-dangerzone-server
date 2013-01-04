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
  end

  def register(data, socket)
    name = data['name']
    remove_user(name)
    count = @users.count 
    return if count >= 4
    user = User.new(name, socket, data['icon'])
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
      msg = {:type => :user, :subtype => :deleted, :data => user.name}.to_json
      message_all(msg)
    end
  end

  def chat_all(_message, user=nil)
    user = find_user(user)
    _message = "|#{user.name}| #{_message}" unless user.nil?
    msg = {:type => :chat, :subtype => :new_message, :data => _message}.to_json
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
    return unless user
    case data['subtype']
    when 'join' then user_join(user)
    when 'leave' then user_leave(user)
    when 'keydown' then key_down(user, data['data'])
    when 'keyup' then key_up(user, data['data'])
    end
  end

  def user_join(user)
    return if user.nil?
    @game.join(user)
  end

  def user_leave(user)
    return if user.nil?
    @game.leave(user)
  end

  def key_down(user, key)
    case key
    when 'left' then user.key_left(1)
    when 'up' then user.key_up(1)
    when 'right' then user.key_right(1)
    when 'down' then user.key_down(1)
    end
  end

  def key_up(user, key)
    case key
    when 'left' then user.key_left(0)
    when 'up' then user.key_up(0)
    when 'right' then user.key_right(0)
    when 'down' then user.key_down(0)
    end
  end

  def ping
    return if @update_running
    @update_running = true
    @game.move_users
    positions = {:user => @game.user_pos, :object => {}}
    data = {:positions => positions}
    msg = {:type => 'game', :subtype => 'state', :data => data}.to_json
    message_all(msg)
    @update_running = false
  end
end

class App

  attr_reader :chat

  def initialize
    @users = {}
    @chat = Chat.new(self)
    @game = Game.new(self)
    @update_running = false
  end

  def register(data, socket)
    name = data['name']
    remove_user(name)

    # only 4 players allowed
    return if @users.count >= 4
    user = User.new(name, socket, data['icon'])
    user.subscribe(@chat.channel, :chat)
    @users[socket] = user

    msg = ChatMessage.new(body: "User '#{name}' signed on")
    @chat.send(msg)

  end

  def remove_user(crit)
    user = find_user(crit)
    unless user.nil?
      @game.leave(user)
      user.unsubscribe(@chat.channel, :chat)

      cmsg = ChatMessage.new(body: "User '#{user.name}' signed off")
      @chat.send(cmsg)

      puts "removed #{user.name}"
      @users.delete user.socket
      msg = {:type => :user, :subtype => :deleted, :name => user.name}.to_json
      @game.channel.push(msg)
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
    when 'public_message'
      user = find_user(socket)
      @chat.send(ChatMessage.new({sender: user, body: data['data']['message']})) if user
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
    when 'rotate' then user.angle = -data['data']
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
    angles = @game.object_angle
    sizes = @game.object_size
    objects ={}
    msg = { :type => 'game', :subtype => 'state', :positions => positions, :angles => angles, :sizes => sizes }.to_json
    @game.channel.push(msg)
    @update_running = false
  end
end

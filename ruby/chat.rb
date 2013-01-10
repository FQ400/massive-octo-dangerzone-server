class Chat

  attr_reader :channel

  def initialize(app)
    @app = app
    @channel = EventMachine::Channel.new
  end

  # msg - instance of ChatMessage
  def send(msg)
    if msg.receiver == :all
      send_to_all(msg)
    elsif msg.receiver.is_a?(User)
      send_to_user(msg)
    end
  end

  # use the channel which all users subscribed
  def send_to_all(msg)
    payload = {
      :type => :chat,
      :subtype => :new_message,
      :message => build_message(msg)
    }.to_json
    @channel.push(payload)
  end

  def send_to_user(msg)
    user = msg.receiver
    user.socket.send(build_message(msg)) if user.is_a?(User)
  end

  private

  def build_message(msg)
    method = case msg.sender.class.to_s
    when 'Symbol'
      :to_s
    when 'User'
      :name
    end
    ('|' + msg.sender.send(method) + '| ' + msg.body)
  end

end



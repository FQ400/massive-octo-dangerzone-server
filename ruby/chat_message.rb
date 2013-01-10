class ChatMessage

  attr_accessor :sender, :receiver, :body

  def initialize(args)
    @sender = args[:sender] || :game
    @receiver = args[:receiver] || :all
    @body = args[:body]
  end

end
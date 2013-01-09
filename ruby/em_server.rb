require 'rubygems'
require 'bundler/setup'
Bundler.require

require 'eventmachine'
require 'em-websocket'
require 'em-hiredis'
require 'json'
require 'matrix'

# require all ruby files of the game
Dir.foreach(File.dirname(__FILE__)) do |file|
  if (File.absolute_path(file) != __FILE__) and not File.directory?(file)
    require File.split(File.absolute_path(__FILE__))[0]+'/'+file
  end
end

EventMachine.run do

  puts 'Game server started... ;)'

  @app = App.new

  EventMachine::WebSocket.start(:host => '0.0.0.0', :port => 9020) do |socket|
  # EventMachine::WebSocket.start(:host => '10.20.1.9', :port => 9020) do |socket|

    socket.onopen do
      puts "WebSocket opened!"
    end

    socket.onmessage do |msg|
      begin
        data = JSON.parse(msg)
      rescue JSON::ParserError => e
        puts e
      else
        # puts data
        case data['type']
        when 'general' then
          case data['subtype']
          when 'init' then @app.register(data['data'], socket)
          end
        when 'chat' then @app.chat_message(data, socket)
        when 'game' then @app.game_message(data, socket)
        end
      end
    end

    socket.onclose do
      @app.remove_user(socket)
      puts "WebSocket closed!"
    end
  end

  EventMachine.add_periodic_timer(0.03) do
    @app.ping
  end
end

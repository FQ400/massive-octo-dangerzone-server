require 'rubygems'
require 'bundler/setup'
Bundler.require

require 'eventmachine'
require 'em-websocket'
require 'em-hiredis'
require 'json'
require 'matrix'

REQUIRE_RELATIVE = [
  'ruby_extension',
  'exceptions'
].each {|file| require_relative file }

# autoload all required files in dir and subdirs
def load_files_of(path)
  Dir.foreach(path) do |file|
    src = [path, file].join('/')
    
    # call yourself if file is a directory
    load_files_of(src) if File.directory?(src) and file != '.' and file != '..'
    
    sym = File.basename(file, '.rb').split('_').map{|el| el.capitalize}.join('').to_sym
    unless (src == __FILE__) or 
      File.directory?(file) or 
      !(src[-3,3] == '.rb') or 
      (REQUIRE_RELATIVE.include?(file))
        autoload sym, src
    end
  end
end

path = File.split(File.absolute_path(__FILE__))[0]
load_files_of(path)


EventMachine.run do

  puts 'Game server started... ;)'

  @app = App.new

  EventMachine::WebSocket.start(:host => '0.0.0.0', :port => 9020) do |socket|
    socket.onopen do
      puts "WebSocket opened!"
    end

    socket.onmessage do |msg|
      begin
        data = JSON.parse(msg)
      rescue JSON::ParserError => e
        puts e
      else
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

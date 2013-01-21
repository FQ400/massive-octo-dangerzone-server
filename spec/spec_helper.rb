require 'rspec'

require 'eventmachine'
require 'em-rspec'
require 'em-websocket'
require 'em-hiredis'
require 'json'
require 'matrix'

APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), ".."))

puts APP_ROOT

DO_NOT_REQUIRE_THIS_FILES = [
  'em_server'
]

Dir["#{APP_ROOT}/ruby/*.rb", "#{APP_ROOT}/ruby/**/*.rb"].each do |f|
  next if DO_NOT_REQUIRE_THIS_FILES.any? { |el| f.include?(el) }
  require f
end

RSpec.configure do |config|
  config.add_formatter 'documentation'
  config.color = true
end

class DummySocket
  def send(mesg)
  end
end

def create_user(name)
  User.new(name, DummySocket.new, {})
end

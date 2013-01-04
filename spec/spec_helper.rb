require 'rspec'

APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), ".."))

DO_NOT_REQUIRE_THIS_FILES = [
  'em_server'
]

Dir["#{APP_ROOT}/ruby/*.rb"].each do |f|
  next if DO_NOT_REQUIRE_THIS_FILES.any? { |el| f.include?(el) }
  require f
end

RSpec.configure do |config|
  config.add_formatter 'documentation'
  config.color = true
end

require_relative '../spec_helper'

describe App do

  it 'should create an instance of the app' do
    App.new.should be_an_instance_of(App)
  end

  it 'should setup an empty hash to store the player' do
    app = App.new
    users = app.instance_variable_get(:@users)
    users.should be_an_instance_of(Hash)
  end
end
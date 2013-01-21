require_relative '../spec_helper'

describe Turbo do

  it 'should triple a user\'s speed' do
    app = App.new
    game = Game.new(app)
    user = create_user('user1')
    pickup = Turbo.new
    game.join(user)
    pickup.apply(user)
    user.speed.should eql(300.0)
  end

end

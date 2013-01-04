require_relative '../spec_helper'

describe Game do

  it 'should create a instance of the Game' do
    Game.new.should be_an_instance_of(Game)
  end

end
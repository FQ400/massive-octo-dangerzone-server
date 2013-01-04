class GameObject
  attr_accessor :id
  attr_accessor :icon
  attr_accessor :position

  def initialize(id, icon, position=Vector[0, 0])
    @id = id
    @icon = icon
    @position = @start_position = position
  end
end

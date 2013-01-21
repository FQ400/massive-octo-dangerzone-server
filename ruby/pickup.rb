class Pickup < GameObject

  def initialize(options)
    options = {
      direction: Vector[0,0]
    }.merge(options)
    super(options)
  end

end

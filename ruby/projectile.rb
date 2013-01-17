class Projectile < GameObject
  attr_reader :owner

  def initialize(icon, start_position, direction, owner, size, speed, ttl, range)
    super(icon, start_position, direction, size, speed, ttl, range)
    @icon = 'http://2.bp.blogspot.com/-cpAEAC9qXNs/TxWEG2f4U2I/AAAAAAAAHw8/nIEdXy7LtI4/s1600/9K720+Iskander+SS-26+Stone+mobile+theater+ballistic+missile+system++quasi-ballistic++solid-propellant+single-stage+guided+missiles%252C+model+9M723K1+cruises+at+hypersonic+speed+++CEP+%2528Circular+error+probable%2529+anti-ABM+maneuver+%2528+%25282%2529.jpg'
    @owner = owner
    @size = 30
  end
end

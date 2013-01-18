class Shrinker < Pickup

  def initialize(options)
    options = {
      icon: 'http://img.informer.com/icons/png/32/3298/3298271.png',
      size: 30,
      speed: 300,
      ttl: -1,
      range: -1
    }.merge(options)
    super(options)
  end
  
  def apply(user)
    user.size /= 3
    kill
  end

end

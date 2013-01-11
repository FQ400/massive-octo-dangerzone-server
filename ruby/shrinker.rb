require_relative 'pickup'

class Shrinker < Pickup

  def initialize(icon, start_position, direction, size, speed, ttl, range)
    super(icon, start_position, direction, size, speed, ttl, range)
    @icon = 'http://i1-news.softpedia-static.com/images/news2/Speed-Download-5-1-4-Available-Download-Here-2.jpg'
    @size = 40
  end

  def apply(user)
    user.size /= 3
  end
end

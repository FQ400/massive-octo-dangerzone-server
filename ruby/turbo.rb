class Turbo < Pickup

  def initialize(options)
    options = {
      icon: 'http://i1-news.softpedia-static.com/images/news2/Speed-Download-5-1-4-Available-Download-Here-2.jpg',
      size: 40,
      speed: 300,
      ttl: -1,
      range: -1,
    }.merge(options)
    super(options)
  end

  def apply(user)
    return if user == @owner
    user.speed *= 3
    kill
  end

end

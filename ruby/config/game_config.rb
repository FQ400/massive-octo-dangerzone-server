module GameConfig
  CONFIG = {
    gameobject: {
      angle: 0,
      position: Vector[0,0],
      direction: Vector[0,0],
      icon: nil,
      killed: false,
      position: Vector[0,0],
      range: 300,
      size: 60,
      speed: 100,
      ttl: -1,
      visible: true
    },
    pickup: {
      direction: Vector[0,0],
      size: 30,
      ttl: -1,
      range: -1,
    },
    turbo: {
      icon: 'http://i1-news.softpedia-static.com/images/news2/Speed-Download-5-1-4-Available-Download-Here-2.jpg',
      size: 40,
      speed: 300,
    },
    shrinker: {
      icon: 'http://img.informer.com/icons/png/32/3298/3298271.png',
      size: 30,
      speed: 300,
      ttl: -1,
      range: -1,
    },
    cloak: {
      icon: 'img/ninja-mask.png',
    },
    user: {
      icon: nil
    },
    projectile: {
      icon: 'img/rocket.jpg',
      size: 30,
      range: 400,
      ttl: 100,
      speed: 300,
    },
    effect: {
      visible: false,
      type: nil
    },
    damageeffect: {
      ttl: -1,
      type: :hp
    },
    deatheffect: {
      ttl: -1,
      type: :visible
    },
    wheeldamageeffect: {
      ttl: -1,
      type: [:hp, :speed]
    },
    invisibilityeffect: {
      ttl: 3,
      type: :visible
    },
    turboeffect: {
      ttl: 3,
      type: :speed
    },
    shrinkeffect: {
      ttl: 3,
      type: :size
    },
  }
  
end

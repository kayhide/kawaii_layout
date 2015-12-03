$ ->
  arts_count = 10
  bond_order = arts_count
  bond_length = 1.5
  bond_factor = 0.01
  radius_min = 40
  radius_max = 80
  for canvas in $('canvas')
    rings = 50
    stage = new createjs.Stage(canvas)
    colors = ["#828b20", "#b0ac31", "#cbc53d", "#fad779", "#f9e4ad", "#faf2db", "#563512", "#9b4a0b", "#d36600", "#fe8a00", "#f9a71f"]

    arts = for i in [0...arts_count]
      art = new createjs.Shape()
      art.radius = Math.random() * (radius_max - radius_min) + radius_min
      for j in [rings..0]
        art.graphics.beginFill(colors[Math.random() * colors.length | 0])
        .drawCircle(0, 0, art.radius * j / rings)
      art.x = canvas.width * (0.5 + Math.random() * 0.4 - 0.2)
      art.y = i * 50 + radius_min
      art.velocity = new createjs.Point(0, 0)
      art.force = new createjs.Point(0, 0)
      art.snapToPixel = true
      art.cache(-art.radius, -art.radius, art.radius * 2, art.radius * 2)
      stage.addChild(art)
      art
    stage.update()

    bonds = []
    for i in [0...arts_count]
      for j in [0...bond_order]
        if arts[i - j]
          bonds.push(
            arts: [arts[i - j], arts[i]]
            length: (arts[i - j].radius + arts[i].radius) * bond_length
          )
    createjs.Ticker.timingMode = createjs.Ticker.RAF
    createjs.Ticker.addEventListener "tick", (event)->
      for bond in bonds
        art0 = bond.arts[0]
        art1 = bond.arts[1]
        vec = art1.position().subtract(art0.position())
        len = vec.length()
        dir = vec.scale(1 / len)
        f = dir.scale((len - bond.length) * bond_factor)
        art0.force = art0.force.add(f)
        art1.force = art1.force.add(f.scale(-1))
      for art in arts
        art.velocity = art.velocity.add(art.force).scale(0.9)
        art.force = new createjs.Point(0, 0)
      for art in arts
        pt = art.position().add(art.velocity)
        art.x = pt.x
        art.y = pt.y
      stage.update(event)

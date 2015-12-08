$ ->
  unless canvas = $('canvas#spring')[0]
    return

  arts_count = 6
  bond_order = 6
  bond_length = 1.2
  bond_factor = 0.05
  repulsion_factor = 0.1
  friction = 0.9
  radius_min = 40
  radius_max = 80

  elm = $(canvas)
  gravity = new createjs.Point(elm.data('gravity-x'), elm.data('gravity-y'))

  stage = new createjs.Stage(canvas)

  arts = []
  bonds = []
  debug = false

  canvas.addArt = ()->
    radius = Math.floor(Math.random() * (radius_max - radius_min) + radius_min)
    art = new Baumkuchen(radius)
    art.x = canvas.width * (0.5 + Math.random() * 0.4 - 0.2)
    art.y = (arts[arts.length - 1]?.y ? 0) + art.radius
    art.mass = Math.max(1, bond_order - arts.length)
    for bonding_art in arts.slice(Math.max(0, arts.length - bond_order))
      canvas.addBondFor(art, bonding_art)
    arts.push(art)
    stage.addChild(art)
    art

  canvas.toggleDebug = ()->
    debug = !debug
    unless debug
      for bond in bonds
        bond.shape.graphics.clear()
    debug

  canvas.addBondFor = (art0, art1)->
    shape = new createjs.Shape()
    bonds.push(
      arts: [art0, art1]
      length: (art0.radius + art1.radius) * bond_length
      shape: shape
    )
    stage.addChild(shape)


  for i in [0...arts_count]
    canvas.addArt()

  createjs.Ticker.timingMode = createjs.Ticker.RAF
  createjs.Ticker.addEventListener "tick", (event)->
    for bond in bonds
      art0 = bond.arts[0]
      art1 = bond.arts[1]
      vec = art1.position().subtract(art0.position())
      len = vec.length()
      dir = vec.scale(1 / len)
      f = dir.scale(-repulsion_factor / len * len + (len - bond.length) * bond_factor)
      art0.force = art0.force.add(f)
      art1.force = art1.force.add(f.scale(-1))
    for art in arts
      art.force = art.force.add(gravity)
      art.velocity = art.velocity.add(art.force).scale(1 / art.mass * friction)
      art.force = new createjs.Point(0, 0)
    for art in arts
      pt = art.position().add(art.velocity)
      art.x = pt.x
      art.y = pt.y
    if debug
      for bond in bonds
        bond.shape.graphics.clear().beginStroke('#333')
        .moveTo(bond.arts[0].x, bond.arts[0].y).lineTo(bond.arts[1].x, bond.arts[1].y).endStroke()
    stage.update(event)

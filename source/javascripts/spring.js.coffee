$ ->
  return unless canvas = $('canvas#spring')[0]

  arts_count = 6
  bond_order = 3
  bond_length = 1.2
  bond_factor = 0.05
  repulsion_factor = 0
  friction = 0.9
  radius_min = 40
  radius_max = 80

  images = false
  debug = false

  elm = $(canvas)
  gravity = new createjs.Point(elm.data('gravity-x'), elm.data('gravity-y'))

  stage = new createjs.Stage(canvas)
  arts_layer = new createjs.Container
  images_layer = new createjs.Container
  bonds_layer = new createjs.Container
  stage.addChild(arts_layer)

  arts = []
  bonds = []

  canvas.addActors = (art)->
    sorted_arts = arts.slice().sort (x, y)->
      -(x.radius - y.radius)
    i = sorted_arts.indexOf(art)
    arts_layer.addChildAt(art.actors[0], i)
    images_layer.addChildAt(art.actors[1], i)

  canvas.addArt = ()->
    radius = Math.floor(Math.random() * (radius_max - radius_min) + radius_min)
    art = {
      radius: radius
      x: canvas.width * (0.5 + Math.random() * 0.4 - 0.2)
      y: (arts[arts.length - 1]?.y ? 0) + radius
      mass: Math.max(1, bond_order - arts.length)
      velocity: new createjs.Point(0, 0)
      force: new createjs.Point(0, 0)
      actors: [new Baumkuchen(radius), new ArtImage(radius)]
      position: ->
        new createjs.Point(@x, @y)
    }
    for bonding_art in arts.slice(Math.max(0, arts.length - bond_order))
      canvas.addBondFor(art, bonding_art)
    arts.push(art)
    canvas.addActors(art)
    art

  canvas.toggleImages = ()->
    images = !images
    if images
      arts_layer.remove()
      stage.addChildAt(images_layer, 0)
    else
      stage.addChildAt(arts_layer, 0)
      images_layer.remove()
    images

  canvas.toggleDebug = ()->
    debug = !debug
    if debug
      stage.addChild(bonds_layer)
    else
      bonds_layer.remove()
    debug

  canvas.addBondFor = (art0, art1)->
    shape = new createjs.Shape()
    bonds.push(
      arts: [art0, art1]
      length: (art0.radius + art1.radius) * bond_length
      shape: shape
    )
    bonds_layer.addChild(shape)

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
      for actor in art.actors
        actor.x = art.x
        actor.y = art.y
    if debug
      for bond in bonds
        bond.shape.graphics.clear().beginStroke('#333')
        .moveTo(bond.arts[0].x, bond.arts[0].y).lineTo(bond.arts[1].x, bond.arts[1].y).endStroke()
    stage.update(event)


  for i in [0...arts_count]
    canvas.addArt()

$ ->
  return unless canvas = $('canvas#tumtum')[0]

  arts_count = 2
  radius_min = 40
  radius_max = 80

  images = false
  debug = false

  stage = new createjs.Stage(canvas)
  arts_layer = new createjs.Container
  images_layer = new createjs.Container
  stage.addChild(arts_layer)

  bodies = []

  b2Vec2    = Box2D.Common.Math.b2Vec2
  b2BodyDef   = Box2D.Dynamics.b2BodyDef
  b2Body    = Box2D.Dynamics.b2Body
  b2FixtureDef  = Box2D.Dynamics.b2FixtureDef
  b2World     = Box2D.Dynamics.b2World
  b2PolygonShape  = Box2D.Collision.Shapes.b2PolygonShape
  b2CircleShape   = Box2D.Collision.Shapes.b2CircleShape
  b2DebugDraw = Box2D.Dynamics.b2DebugDraw

  world = new b2World(new b2Vec2(0, -10), true)
  SCALE = 40
  width = canvas.width / SCALE
  height = canvas.height / SCALE

  fixDef = new b2FixtureDef
  fixDef.density = 1.0

  do ->
    bodyDef = new b2BodyDef
    bodyDef.type = b2Body.b2_staticBody
    fixDef.shape = new b2PolygonShape

    w = 0.1
    bodyDef.position.Set(width / 2, 0)
    fixDef.shape.SetAsBox(width / 2, w)
    world.CreateBody(bodyDef).CreateFixture(fixDef)

    bodyDef.position.Set(w, height / 2)
    fixDef.shape.SetAsBox(0, height / 2)
    world.CreateBody(bodyDef).CreateFixture(fixDef)

    bodyDef.position.Set(width, height / 2)
    fixDef.shape.SetAsBox(w, height / 2)
    world.CreateBody(bodyDef).CreateFixture(fixDef)

  canvas.addArt = ()->
    radius = Math.floor(Math.random() * (radius_max - radius_min) + radius_min)
    bodyDef = new b2BodyDef
    bodyDef.type = b2Body.b2_dynamicBody
    fixDef.shape = new b2CircleShape(0.8 * radius / SCALE)

    bodyDef.position.Set(
      width * (0.1 + Math.random() * 0.8),
      height + Math.random()
    )
    body = world.CreateBody(bodyDef)
    body.CreateFixture(fixDef)
    bodies.push body

    body.actors = [new Baumkuchen(radius), new ArtImage(radius)]
    arts_layer.addChild(body.actors[0])
    images_layer.addChild(body.actors[1])

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
    if debug && !@debugDraw
      @debugDraw = new b2DebugDraw()
      @debugDraw.SetSprite(canvas.getContext("2d"))
      @debugDraw.SetDrawScale(SCALE)
      @debugDraw.SetFillAlpha(0.3)
      @debugDraw.SetLineThickness(1.0)
      @debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit)
      world.SetDebugDraw(@debugDraw)
    debug

  createjs.Ticker.timingMode = createjs.Ticker.RAF
  createjs.Ticker.addEventListener "tick", (event)->
    world.Step(1/60, 3, 3)
    world.ClearForces()
    if debug
      world.DrawDebugData()
    else
      for body in bodies
        p = body.GetPosition()
        if p && p.x? && p.y?
          for actor in body.actors
            actor.x = p.x * SCALE
            actor.y = p.y * SCALE
      stage.update(event)


  for i in [0...arts_count]
    canvas.addArt()

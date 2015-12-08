$ ->
  unless canvas = $('canvas#tumtum')[0]
    return

  stage = new createjs.Stage(canvas)
  bodies = []

  b2Vec2    = Box2D.Common.Math.b2Vec2
  b2BodyDef   = Box2D.Dynamics.b2BodyDef
  b2Body    = Box2D.Dynamics.b2Body
  b2FixtureDef  = Box2D.Dynamics.b2FixtureDef
  b2World     = Box2D.Dynamics.b2World
  b2PolygonShape  = Box2D.Collision.Shapes.b2PolygonShape
  b2CircleShape   = Box2D.Collision.Shapes.b2CircleShape

  world = new b2World(new b2Vec2(0, 10),  true)
  up = new b2Vec2(0, -5)

  bxFixDef  = new b2FixtureDef()
  bxFixDef.shape  = new b2PolygonShape()
  blFixDef  = new b2FixtureDef()
  blFixDef.shape  = new b2CircleShape()
  bxFixDef.density  = blFixDef.density = 1

  bodyDef = new b2BodyDef()
  bodyDef.type = b2Body.b2_staticBody

  bxFixDef.shape.SetAsBox(10, 1)
  bodyDef.position.Set(9, stage.stageHeight/100 + 1)
  world.CreateBody(bodyDef).CreateFixture(bxFixDef)

  bxFixDef.shape.SetAsBox(1, 100)

  bodyDef.position.Set(-1, 3)
  world.CreateBody(bodyDef).CreateFixture(bxFixDef)

  bodyDef.position.Set(stage.stageWidth/100 + 1, 3)
  world.CreateBody(bodyDef).CreateFixture(bxFixDef)

  bxBD = new BitmapData("images/box.jpg")
  blBD = new BitmapData("images/bigball.png")

  bodyDef.type = b2Body.b2_dynamicBody
  for i in [0..50]
    hw = 0.1 + Math.random()*0.45
    hh = 0.1 + Math.random()*0.45

    bxFixDef.shape.SetAsBox(hw, hh)
    blFixDef.shape.SetRadius(hw)
    bodyDef.position.Set(Math.random()*7, -5 + Math.random()*5)

    body = world.CreateBody(bodyDef)
    if i < 25
      body.CreateFixture(bxFixDef)
    else
      body.CreateFixture(blFixDef)
    bodies.push(body)

    bm = new createjs.Bitmap(i<25 ? bxBD : blBD)
    bm.x = bm.y = -100
    bm.scaleX = bm.scaleY = hw
    body.actor = bm
    stage.addChild(body.actor)

  createjs.Ticker.timingMode = createjs.Ticker.RAF
  createjs.Ticker.addEventListener "tick", (event)->
    world.Step(1 / 60,    3,    3)
    world.ClearForces()
    for body in bodies
      actor = body.actor
      p = body.GetPosition()
      if p && p.x? && p.y?
        actor.x = p.x *100
        actor.y = p.y *100
        actor.rotation = body.GetAngle()*180/Math.PI
    stage.update(event)

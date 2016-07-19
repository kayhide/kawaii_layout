$ ->
  return unless canvas = $('canvas#tumtum')[0]

  arts_count = 10

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
  b2AABB = Box2D.Collision.b2AABB
  b2MouseJointDef = Box2D.Dynamics.Joints.b2MouseJointDef

  elm = $(canvas)
  gravity = new b2Vec2(elm.data('gravity-x'), elm.data('gravity-y'))

  world = new b2World(gravity, true)
  SCALE = canvas.width
  width = canvas.width / SCALE
  height = canvas.height / SCALE

  fixDef = new b2FixtureDef
  fixDef.density = 1.0

  $artsCount = $('#arts-count')

  mousePoint = new b2Vec2()
  mouseJoint = null

  getRadiusMin = ->
    parseFloat($('#radius-min').val())

  getRadiusMax = ->
    parseFloat($('#radius-max').val())

  getBodyRatio = ->
    parseFloat($('#body-ratio').val())

  boundary = do ->
    boundaryDef = new b2BodyDef()
    boundaryDef.type = b2Body.b2_staticBody
    boundary = world.CreateBody(boundaryDef)

    thickness = 0.1
    wallHeight = 100 * height

    topDef = new b2FixtureDef
    topDef.shape = new b2PolygonShape()
    topDef.shape.SetAsOrientedBox(width/2, thickness, new b2Vec2(width/2, -thickness), 0)

    leftDef = new b2FixtureDef
    leftDef.shape = new b2PolygonShape()
    leftDef.shape.SetAsOrientedBox(thickness, wallHeight, new b2Vec2(-thickness, 0), 0)

    rightDef = new b2FixtureDef
    rightDef.shape = new b2PolygonShape()
    rightDef.shape.SetAsOrientedBox(thickness, wallHeight, new b2Vec2(width+thickness, 0), 0)

    boundary.CreateFixture(topDef)
    boundary.CreateFixture(leftDef)
    boundary.CreateFixture(rightDef)

    boundary


  handleMouseDown = (event) ->
    mouseX = event.stageX
    mouseY = event.stageY
    mousePoint.Set mouseX / SCALE, mouseY / SCALE
    hitBody = getBodyAtMouse()
    if hitBody
      #if joint exists then create
      def = new b2MouseJointDef()
      def.bodyA = boundary
      def.bodyB = hitBody
      def.target = mousePoint
      def.collideConnected = true
      def.maxForce = 1000 * hitBody.GetMass()
      def.dampingRatio = 0
      mouseJoint = world.CreateJoint(def)

      hitBody.SetAwake true
    return

  handleMouseMove = (event) ->
    mouseX = event.stageX
    mouseY = event.stageY
    mousePoint.Set mouseX / SCALE, mouseY / SCALE
    if mouseJoint
      mouseJoint.SetTarget mousePoint
    return

  handleMouseUp = (event) ->
    @onMouseMove = @onMouseUp = null
    if mouseJoint
      world.DestroyJoint mouseJoint
      mouseJoint = false
    return

  getBodyAtMouse = (includeStatic) ->
    body = null
    aabb = new b2AABB()

    getBodyCallback = (fixture) ->
      shape = fixture.GetShape()
      if fixture.GetBody().GetType() != b2Body.b2_staticBody or includeStatic
        inside = shape.TestPoint(fixture.GetBody().GetTransform(), mousePoint)
        if inside
          body = fixture.GetBody()
          return false
      true

    aabb.lowerBound.Set mousePoint.x - 0.001, mousePoint.y - 0.001
    aabb.upperBound.Set mousePoint.x + 0.001, mousePoint.y + 0.001
    world.QueryAABB getBodyCallback, aabb
    body

  canvas.showArtsCount = ->
    $artsCount.text bodies.length

  canvas.addActors = (body)->
    arts_layer.addChild(body.actors[0])
    images_layer.addChild(body.actors[1])

  canvas.addArt = ()->
    radius = Math.random() * (getRadiusMax() - getRadiusMin()) + getRadiusMin()
    bodyDef = new b2BodyDef
    bodyDef.type = b2Body.b2_dynamicBody
    fixDef.shape = new b2CircleShape(getBodyRatio() * radius)

    ys = (body.GetPosition().y + body.radius for body in bodies when body.GetPosition().y isnt NaN)
    y = if (ys.length > 0) then Math.max.apply(null, ys) else radius
    bodyDef.position.Set(
      width * (0.1 + Math.random() * 0.8),
      y
    )
    body = world.CreateBody(bodyDef)
    body.CreateFixture(fixDef)
    i = bodies.push body

    body.radius = radius

    artImage = new ArtImage(radius * SCALE, i)
    artImage.addEventListener("mousedown", handleMouseDown)
    artImage.addEventListener("pressmove", handleMouseMove)
    artImage.addEventListener("pressup", handleMouseUp)
    baumkuchen = new Baumkuchen(radius * SCALE)

    body.actors = [artImage, baumkuchen]

    canvas.addActors(body)
    canvas.showArtsCount()

  canvas.addArt10 = ()->
    for i in [1..10]
      canvas.addArt()

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

  canvas.reset = ()->
    for body in bodies
      world.DestroyBody(body)
      arts_layer.removeChild(body.actors[0])
      images_layer.removeChild(body.actors[1])
    bodies = []
    canvas.showArtsCount()
    false

  canvas.dump = ()->
    elements = for body in bodies
      x: body.GetPosition().x
      y: body.GetPosition().y
      radius: body.radius
    data = {
      count: elements.length
      elements: elements
    }
    $('#output').text(JSON.stringify(data))

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

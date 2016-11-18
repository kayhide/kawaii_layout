class Gesture extends Object
  Vec2 = Box2D.Common.Math.b2Vec2

  constructor: ()->
    super()
    @mousePoint = new Vec2()
    @mouseDownPoint = new Vec2()
    @scale = 1.0
    @listeners = {}
    @isMoved = false
    @isLongPressed = false
    @event = null

  shiftKey: =>
    @event?.nativeEvent?.shiftKey

  setScale: (scale)=>
    @scale = scale

  attach: (elm)=>
    elm.addEventListener("mousedown", @handleMouseDown)
    elm.addEventListener("pressmove", @handleMouseMove)
    elm.addEventListener("pressup", @handleMouseUp)

  on: (e, fn)=>
    @listeners[e] ?= []
    @listeners[e].push(fn)

  handleMouseDown: (event)=>
    @event = event
    @mousePoint.Set event.stageX / @scale, event.stageY / @scale
    @mouseDownPoint.Set @mousePoint.x, @mousePoint.y
    @isMoved = false
    @isLongPressed = false
    fn() for fn in @listeners['mousedown'] ? []
    setTimeout =>
      if !@isMoved
        @handleMouseLongPress()
    , 500
    return

  handleMouseMove: (event)=>
    @event = event
    @mousePoint.Set event.stageX / @scale, event.stageY / @scale
    @isMoved = true
    fn() for fn in @listeners['pressmove'] ? []
    return

  handleMouseUp: (event) =>
    @event = event
    fn() for fn in @listeners['pressup'] ? []
    return

  handleMouseLongPress: () =>
    @isLongPressed = true
    fn() for fn in @listeners['longpress'] ? []
    return

@Gesture = Gesture

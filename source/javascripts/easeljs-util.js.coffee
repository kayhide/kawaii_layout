createjs.Point::add = (p) ->
  new createjs.Point(@x + p.x, @y + p.y)

createjs.Point::subtract = (p) ->
  new createjs.Point(@x - p.x, @y - p.y)

createjs.Point::scale = (d) ->
  new createjs.Point(@x * d, @y * d)

createjs.Point::apply = (mtx) ->
  mtx = mtx.clone()
  mtx.append(1, 0, 0, 1, @x, @y)
  new createjs.Point(mtx.tx, mtx.ty)

createjs.Point::distanceTo = (pt) ->
  Math.sqrt(Math.pow(pt.x - @x, 2) + Math.pow(pt.y - @y, 2))

createjs.Point::isZero = ->
  @x == 0 and @y == 0

createjs.Point::length = ->
  Math.sqrt(Math.pow(@x, 2) + Math.pow(@y, 2))

createjs.Point::regularize = ->
  @scale(1 / @length())

createjs.Rectangle.createEmpty = ->
  rect = new createjs.Rectangle()
  rect.empty = true
  rect

createjs.Rectangle::clear = ->
  @empty = true
  this

createjs.Rectangle::isEmpty = ->
  @empty?

createjs.Rectangle::addPoint = (pt) ->
  if @empty?
    @x = pt.x
    @y = pt.y
    @width = 0
    @height = 0
    @empty = null
    @points = [pt]
  else
    @points.push(pt)
    if pt.x < @x
      @width += @x - pt.x
      @x = pt.x
    else if pt.x > @x + @width
      @width = pt.x - @x
    if pt.y < @y
      @height += @y - pt.y
      @y = pt.y
    else if pt.y > @y + @height
      @height = pt.y - @y
  this

createjs.Rectangle::addRectangle = (rect) ->
  for pt in rect.getCornerPoints()
    @addPoint(pt)
  this

createjs.Rectangle::getTopLeft = -> new createjs.Point(@x, @y)

createjs.Rectangle::getTopRight = -> new createjs.Point(@x + @width, @y)

createjs.Rectangle::getBottomLeft = -> new createjs.Point(@x, @y + @height)

createjs.Rectangle::getBottomRight = -> new createjs.Point(@x + @width, @y + @height)

createjs.Rectangle::getCornerPoints = ->
  [@getTopLeft(), @getTopRight(), @getBottomLeft(), @getBottomRight()]

createjs.Rectangle::getCenter = ->
  new createjs.Point(@x + @width / 2, @y + @height / 2)

createjs.Rectangle::getRight = ->
  @x + @width

createjs.Rectangle::getBottom = ->
  @y + @height

createjs.Rectangle::inflate = (offset) ->
  @x -= offset
  @y -= offset
  @width += offset * 2
  @height += offset * 2
  this

createjs.Point.boundary = (points) ->
  rect = createjs.Rectangle.createEmpty()
  for pt in points
    rect.addPoint(pt)
  rect

createjs.Point::toArray = -> [@x, @y]

createjs.Point::from = (obj) ->
  pt = @clone()
  pt.on = obj
  pt

createjs.Point::to = (obj) ->
  if @on?
    if @on.getStage() == obj.getStage()
      if @on_global?
        pt = obj.globalToLocal(@x, @y)
      else
        pt = @on.localToLocal(@x, @y, obj)
    else
      if @on_global?
        pt = @on.globalToWindow(@x, @y)
        pt = obj.windowToLocal(pt.x, pt.y)
      else
        pt = @on.localToWindow(@x, @y)
        pt = obj.windowToLocal(pt.x, pt.y)
  else if @on_window?
    pt = obj.windowToLocal(@x, @y)
  else
    pt = obj.globalToLocal(@x, @y)
  pt.on = obj
  pt.on_global = null
  pt.on_window = null
  pt

createjs.Point::toGlobal = ->
  if @on? and !@on_window? and !@on_global?
    pt = @on.localToGlobal(@x, @y)
    pt.on_global = true
  else
    pt = @clone()
  pt.on_window = null
  pt

createjs.Point::fromWindow = ->
  pt = @clone()
  pt.on_global = null
  pt.on_window = true
  pt

createjs.Point::toWindow = ->
  if @on?
    if @on_global?
      pt = @on.globalToWindow(@x, @y)
    else
      pt = @on.localToWindow(@x, @y)
  else
    pt = @clone()
  pt.on = null
  pt.on_global = null
  pt.on_window = true
  pt

createjs.DisplayObject::remove = ->
  @parent?.removeChild(this)

createjs.DisplayObject::position = ->
  new createjs.Point(@x, @y)

createjs.DisplayObject::localToParent = (x, y) ->
  @localToLocal(x, y, @parent)

createjs.DisplayObject::copyTransform = (src) ->
  { @x, @y, @scaleX, @scaleY, @rotation } = src

createjs.DisplayObject::clearTransform = ->
  @setTransform()

createjs.DisplayObject::projectTo = (dst) ->
  pt0 = @localToWindow(0, 0)
  pt1 = dst.windowToLocal(pt0.x, pt0.y)
  { @x, @y } = pt1
  dst.addChild(this)

createjs.DisplayObject::localToWindow = (x, y) ->
  pt0 = $(@getStage().canvas).position()
  pt = @localToGlobal(x, y)
  pt.x += pt0.left
  pt.y += pt0.top
  pt

createjs.DisplayObject::windowToLocal = (x, y) ->
  pt0 = $(@getStage().canvas).position()
  pt = @globalToLocal(x - pt0.left, y - pt0.top)
  pt

createjs.DisplayObject::globalToWindow = (x, y) ->
  pt0 = $(@getStage().canvas).position()
  new createjs.Point(x + pt0.left, y + pt0.top)

createjs.DisplayObject::windowToGlobal = (x, y) ->
  pt0 = $(@getStage().canvas).position()
  new createjs.Point(x - pt0.left, y - pt0.top)

createjs.Stage::invalidate = ->
  @invalidated = true


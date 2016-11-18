class ArtImage extends createjs.Container
  textOutlineColors =
    "dynamic": "#000"
    "static": "#fff"
    "captured": "#66f"

  textColors =
    "dynamic": "#fff"
    "static": "#f00"
    "selected": "#0ff"

  alphas =
    "dynamic": 1
    "static": 0.5
    "captured": 1

  constructor: (@radius, i)->
    super()

    src = ArtImages[ArtImages.length * Math.random() | 0]
    bounds = new createjs.Rectangle(0, 0, 150, 150)

    @index = i

    @bitmap = new createjs.Bitmap(src)
    @bitmap.regX = bounds.width / 2
    @bitmap.regY = bounds.height / 2
    @bitmap.scaleX = 2 * @radius / bounds.width
    @bitmap.scaleY = 2 * @radius / bounds.height

    @textOutline = new createjs.Text(i, "20px Arial", null)
    @textOutline.outline = 4
    textBounds = @textOutline.getBounds()
    @textOutline.x -= textBounds.width / 2
    @textOutline.y -= textBounds.height / 2

    @text = @textOutline.clone()
    @text.outline = false

    @addChild @bitmap, @textOutline, @text

  updateIndex: (i)=>
    @index = i
    @textOutline.text = @index
    textBounds = @textOutline.getBounds()
    @textOutline.x = -textBounds.width / 2
    @textOutline.y = -textBounds.height / 2
    @text.text = @index
    @text.x = @textOutline.x
    @text.y = @textOutline.y

  markAsDynamic: => @markAs "dynamic"
  markAsStatic: => @markAs "static"
  markAsCaptured: => @markAs "captured"
  markAsSelected: => @markAs "selected"
  markAs: (type)=>
    if textColors[type]?
      @text.color = textColors[type]
    if textOutlineColors[type]?
      @textOutline.color = textOutlineColors[type]
    if alphas[type]?
      @bitmap.alpha = alphas[type]



@ArtImage = ArtImage

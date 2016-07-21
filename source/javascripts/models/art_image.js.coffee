class ArtImage extends createjs.Container
  constructor: (@radius, i)->
    super()

    src = ArtImages[ArtImages.length * Math.random() | 0]
    bounds = new createjs.Rectangle(0, 0, 150, 150)

    @bitmap = new createjs.Bitmap(src)
    @bitmap.regX = bounds.width / 2
    @bitmap.regY = bounds.height / 2
    @bitmap.scaleX = 2 * @radius / bounds.width
    @bitmap.scaleY = 2 * @radius / bounds.height

    @textOutlineColors = {
      "dynamic": "#000",
      "static": "#fff",
    }
    @textColors = {
      "dynamic": "#fff",
      "static": "#f00",
    }
    @alphas = {
      "dynamic": 1,
      "static": 0.5
    }

    @textOutline = new createjs.Text(i, "20px Arial", null)
    @textOutline.outline = 4
    textBounds = @textOutline.getBounds()
    @textOutline.x -= textBounds.width / 2
    @textOutline.y -= textBounds.height / 2

    @text = @textOutline.clone()
    @text.outline = false

    @addChild @bitmap, @textOutline, @text

  markAsDynamic: () => @markAs "dynamic"
  markAsStatic: () => @markAs "static"
  markAs: (type) =>
    @text.color = @textColors[type]
    @textOutline.color = @textOutlineColors[type]
    @bitmap.alpha = @alphas[type]



@ArtImage = ArtImage

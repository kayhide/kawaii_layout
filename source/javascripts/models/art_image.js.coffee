class ArtImage extends createjs.Container
  constructor: (@radius, i)->
    super()

    src = ArtImages[ArtImages.length * Math.random() | 0]
    bounds = new createjs.Rectangle(0, 0, 150, 150)

    bitmap = new createjs.Bitmap(src)
    bitmap.regX = bounds.width / 2
    bitmap.regY = bounds.height / 2
    bitmap.scaleX = 2 * @radius / bounds.width
    bitmap.scaleY = 2 * @radius / bounds.height

    textOutlineColor = "#000"
    textColor =  "#fff"

    textOutline = new createjs.Text(i, "20px Arial", textOutlineColor)
    textOutline.outline = 4
    textBounds = textOutline.getBounds()
    textOutline.x -= textBounds.width / 2
    textOutline.y -= textBounds.height / 2

    text = textOutline.clone()
    text.outline = false
    text.color = textColor

    @addChild bitmap, textOutline, text

@ArtImage = ArtImage

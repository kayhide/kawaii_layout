class ArtImage extends createjs.Bitmap
  constructor: (@radius)->
    src = ArtImages[ArtImages.length * Math.random() | 0]
    super(src)
    bounds = new createjs.Rectangle(0, 0, 150, 150)
    @regX = bounds.width / 2
    @regY = bounds.height / 2
    @scaleX = 2 * @radius / bounds.width
    @scaleY = 2 * @radius / bounds.height

@ArtImage = ArtImage

class Baumkuchen extends createjs.Shape
  radius: 10
  rings_count: 50

  constructor: (@radius)->
    colors = ["#828b20", "#b0ac31", "#cbc53d", "#fad779", "#f9e4ad", "#faf2db", "#563512", "#9b4a0b", "#d36600", "#fe8a00", "#f9a71f"]
    super()
    for j in [@rings_count..0]
      @graphics.beginFill(colors[Math.random() * colors.length | 0])
      .drawCircle(0, 0, @radius * j / @rings_count)
    @snapToPixel = true
    @cache(-@radius, -@radius, @radius * 2, @radius * 2)

@Baumkuchen = Baumkuchen

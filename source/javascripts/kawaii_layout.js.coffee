$ ->
  element_count = 3
  for canvas in $('canvas')
    rings = 50
    radius = 40
    stage = new createjs.Stage(canvas)
    colors = ["#828b20", "#b0ac31", "#cbc53d", "#fad779", "#f9e4ad", "#faf2db", "#563512", "#9b4a0b", "#d36600", "#fe8a00", "#f9a71f"]

    for i in [1..element_count]
      shape = new createjs.Shape()
      for j in [rings..0]
        shape.graphics.beginFill(colors[Math.random() * colors.length | 0])
        .drawCircle(0, 0, radius * j / rings)
      shape.x = Math.random() * canvas.width
      shape.y = Math.random() * canvas.height
      shape.velX = Math.random() * 10 - 5
      shape.velY = Math.random() * 10 - 5
      shape.snapToPixel = true
      shape.cache(-radius, -radius, radius * 2, radius * 2)
      stage.addChild(shape)
    stage.update()

    createjs.Ticker.timingMode = createjs.Ticker.RAF
    createjs.Ticker.addEventListener "tick", (event)->
      w = canvas.width
      h = canvas.height
      for shape in stage.children
        shape.x = (shape.x + shape.velX + radius + w + radius * 2) % (w + radius * 2) - radius
        shape.y = (shape.y + shape.velY + radius + h + radius * 2) % (h + radius * 2) - radius
      stage.update(event)

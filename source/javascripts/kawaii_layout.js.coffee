$ ->
  $('#add-art').on 'click', (e)->
    if canvas = $('canvas')[0]
      canvas.addArt?()

  $('#toggle-images').on 'click', (e)->
    if canvas = $('canvas')[0]
      if canvas.toggleImages?()
        $(@).addClass('active')
      else
        $(@).removeClass('active')

  $('#toggle-debug').on 'click', (e)->
    if canvas = $('canvas')[0]
      if canvas.toggleDebug?()
        $(@).addClass('active')
      else
        $(@).removeClass('active')

@ArtImages = []
$ =>
  @ArtImages = (img.src for img in $('#art-images img'))

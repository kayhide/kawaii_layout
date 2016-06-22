$ ->
  $('[data-action]').on 'click', (e)->
    action = $(@).data('action')
    for canvas in $('canvas')
      canvas[action]($('form'))

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

  $('#reset').on 'click', (e)->
    if canvas = $('canvas')[0]
      canvas.reset?()

@ArtImages = []
$ =>
  @ArtImages = (img.src for img in $('#art-images img'))

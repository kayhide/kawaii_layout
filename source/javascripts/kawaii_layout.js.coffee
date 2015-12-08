$ ->
  $('#add-art').on 'click', (e)->
    if canvas = $('canvas')[0]
      canvas.addArt?()

  $('#toggle-debug').on 'click', (e)->
    if canvas = $('canvas')[0]
      if canvas.toggleDebug?()
        $(@).addClass('active')
      else
        $(@).removeClass('active')

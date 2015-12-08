$ ->
  $('#add-art').on 'click', (e)->
    for canvas in $('canvas')
      canvas.addArt()

  $('#toggle-show-bonds').on 'click', (e)->
    for canvas in $('canvas')
      canvas.toggleShowBonds()

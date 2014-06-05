class window.EndTurnMenu

    constructor: (@ui) ->
        @menu = $('.end-turn')

    init: ->
        padding = 5
        @menu.css(@ui.centerElement(@menu, padding))
        @menu.css('padding', padding)
        @show()

    show: ->
        @ui.canvasOverlay.show()
        @menu.css('visibility', 'visible')

    hide: ->
        @ui.canvasOverlay.hide()
        @menu.css('visibility', 'hidden')

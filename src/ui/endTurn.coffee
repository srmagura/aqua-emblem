class window.EndTurnMenu

    constructor: (@ui) ->
        @menu = $('.end-turn')

    init: ->
        padding = 5
        @menu.css(@ui.centerElement(@menu, padding))
        @ui.controlState = new CsEndTurnMenu(@ui, this)
        @show()

    show: ->
        @ui.canvasOverlay.show()
        @menu.css('visibility', 'visible')

    hide: ->
        @ui.canvasOverlay.hide()
        @menu.css('visibility', 'hidden')

class CsEndTurnMenu extends ControlState

    constructor: (@ui, @menuObj) ->

    f: ->
        @menuObj.hide()
        ch = @ui.chapter
        ch.initTurn(ch.enemyTeam)

    d: ->
        @menuObj.hide()
        @ui.controlState = new CsMap(@ui)

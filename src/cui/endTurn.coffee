class _cui.EndTurnMenu

    constructor: (@ui) ->
        @menu = $('.end-turn')

    init: ->
        padding = 5
        @menu.css(@ui.centerElement(@menu, padding))
        @ui.controlState = new _cs.cui.EndTurnMenu(@ui, this)
        @show()

    show: ->
        @ui.canvasOverlay.show()
        @menu.css('visibility', 'visible')

    hide: ->
        @ui.canvasOverlay.hide()
        @menu.css('visibility', 'hidden')

class _cs.cui.EndTurnMenu extends _cs.cui.Chapter

    constructor: (@ui, @menuObj) ->

    f: ->
        @menuObj.hide()
        ch = @ui.chapter
        ch.initTurn(ch.enemyTeam)

    d: ->
        @menuObj.hide()
        @ui.controlState = new _cs.cui.Map(@ui)

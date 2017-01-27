class _chapterui.EndTurnMenu

    constructor: (@ui) ->
        @menu = $('.end-turn')

    init: ->
        padding = 5
        @menu.css(@ui.centerElement(@menu, padding))
        @ui.controlState = new _cs.chapterui.EndTurnMenu(@ui, this)
        @show()

    show: ->
        @ui.canvasOverlay.show()
        @menu.css('visibility', 'visible')

    hide: ->
        @ui.canvasOverlay.hide()
        @menu.css('visibility', 'hidden')

class _cs.chapterui.EndTurnMenu extends _cs.chapterui.Chapter

    constructor: (@ui, @menuObj) ->

    f: ->
        @menuObj.hide()
        ch = @ui.chapter
        ch.initTurn(ch.enemyTeam)

    d: ->
        @menuObj.hide()
        @ui.controlState = new _cs.chapterui.Map(@ui)

class _cs.chapterui.MapAbstract extends _cs.chapterui.Chapter

    up: ->
        if @ui.cursor.pos.i - 1 >= 0
            @ui.cursor.move(-1, 0)

    down: ->
        if @ui.cursor.pos.i + 1 < @ui.chapter.map.height
            @ui.cursor.move(1, 0)

    left: ->
        if @ui.cursor.pos.j - 1 >= 0
            @ui.cursor.move(0, -1)

    right: ->
        if @ui.cursor.pos.j + 1 < @ui.chapter.map.width
            @ui.cursor.move(0, 1)

    s: ->
        unit = @ui.chapter.getUnitAt(@ui.cursor.pos)

        if unit?
            @ui.unitInfoWindow.init(unit)

    e: ->
        @ui.endTurnMenu.init()

    moved: ->
        @ui.terrainBox.init()

class _cs.chapterui.Map extends _cs.chapterui.MapAbstract

    f: ->
        pt = @ui.chapter.playerTurn
        if not pt.selectedUnit?
            unit = @ui.chapter.getUnitAt(@ui.cursor.pos)
            if unit? and not unit.done
                pt.select(unit)
        else if pt.dest.pos.equals(@ui.cursor.pos)
            pt.initMove()

    d: ->
        @ui.chapter.playerTurn.deselect()

    e: ->
        @ui.chapter.playerTurn.deselect()
        super()

class _cs.chapterui.EnemySelected extends _cs.chapterui.Map
    f: ->
    d: ->
        super()
        @ui.controlState = new _cs.chapterui.Map(@ui)

class _cs.chapterui.MapTarget extends _cs.chapterui.MapAbstract

    constructor: (@ui, @playerTurn) ->

class _cs.chapterui.ChooseAttackTarget extends _cs.chapterui.MapTarget

    moved: ->
        super()
        target = @ui.chapter.getUnitAt(@ui.cursor.pos)

        if target isnt null and target in @playerTurn.inAttackRange
            @playerTurn.battle = new _enc.Battle(@ui,
                @playerTurn.selectedUnit, target)

            @ui.battleStatsPanel.init(@playerTurn.battle)
        else
            @playerTurn.battle = null
            @ui.battleStatsPanel.hide()

    f: ->
        if @playerTurn.battle?
            @ui.cursor.visible = false
            @ui.chapter.map.clearOverlay()
            @ui.battleStatsPanel.hide()
            @ui.unitInfoBox.hide()
            @ui.terrainBox.hide()
            @playerTurn.battle.doEncounter(@playerTurn.afterBattle)
            @ui.controlState = new _cs.chapterui.Chapter(@ui)

    d: ->
        @playerTurn.battle = null
        @ui.battleStatsPanel.hide()
        @ui.cursor.moveTo(@playerTurn.selectedUnit.pos)
        
        @ui.weaponMenu.init()


class _cs.chapterui.ChooseTradeTarget extends _cs.chapterui.MapTarget

    f: ->
        callback = (tradeMade) =>
            if tradeMade
                @playerTurn.selectedUnit.setDone()
                @playerTurn.deselect()
                @ui.controlState = new _cs.chapterui.Map(@ui)

        target = @ui.chapter.getUnitAt(@ui.cursor.pos)
        if target isnt null and target in @playerTurn.inTradeRange
            @ui.tradeWindow.init(@playerTurn.selectedUnit, target,
                callback)

    d: ->
        @ui.actionMenu.init(@playerTurn.selectedUnit)
        @ui.cursor.moveTo(@playerTurn.selectedUnit.pos)
        @ui.controlState = new _cs.chapterui.ActionMenuMain(@ui, @ui.actionMenu)

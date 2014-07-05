class _cs.MapAbstract extends _cs.Chapter

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

    moved: ->
        @ui.terrainBox.init()

class _cs.Map extends _cs.MapAbstract

    f: ->
        pt = @ui.chapter.playerTurn
        if not pt.selectedUnit?
            unit = @ui.chapter.getUnitAt(@ui.cursor.pos)
            if unit? and unit.team is @ui.chapter.playerTeam and
            not unit.done
                pt.select(unit)
        else if pt.dest.pos.equals(@ui.cursor.pos)
            pt.initMove()

    d: ->
        @ui.chapter.playerTurn.deselect()

    e: ->
        @ui.chapter.playerTurn.deselect()
        @ui.endTurnMenu.init()

class _cs.MapTarget extends _cs.MapAbstract

    constructor: (@ui, @playerTurn) ->

class _cs.ChooseAttackTarget extends _cs.MapTarget

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
            @ui.controlState = new _cs.Chapter(@ui)

    d: ->
        @ui.actionMenu.show()
        @playerTurn.battle = null
        @ui.battleStatsPanel.hide()
        @ui.cursor.moveTo(@playerTurn.selectedUnit.pos)
        @ui.controlState = new _cs.ActionMenu(@ui, @ui.actionMenu)


class _cs.ChooseTradeTarget extends _cs.MapTarget

    f: ->
        callback = (tradeMade) =>
            if tradeMade
                @playerTurn.selectedUnit.setDone()
                @playerTurn.deselect()
                @ui.controlState = new _cs.Map(@ui)

        target = @ui.chapter.getUnitAt(@ui.cursor.pos)
        if target isnt null and target in @playerTurn.inTradeRange
            @ui.tradeWindow.init(@playerTurn.selectedUnit, target,
                callback)

    d: ->
        @ui.actionMenu.init(@playerTurn.selectedUnit)
        @ui.cursor.moveTo(@playerTurn.selectedUnit.pos)
        @ui.controlState = new _cs.ActionMenu(@ui, @ui.actionMenu)

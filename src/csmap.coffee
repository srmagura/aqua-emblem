class CsMapAbstract extends ControlState

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

class window.CsMap extends CsMapAbstract

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
        @ui.endTurnMenu.init()


class window.CsChooseTarget extends CsMapAbstract

    constructor: (@ui, @playerTurn) ->

    moved: ->
        super()
        target = @ui.chapter.getUnitAt(@ui.cursor.pos)

        if target isnt null and target in @playerTurn.inRange
            @playerTurn.battle = new Battle(@ui,
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
            @playerTurn.battle.doBattle(@playerTurn.afterBattle)
            @ui.controlState = new ControlState(@ui)

    d: ->
        @ui.actionMenu.show()
        @playerTurn.battle = null
        @ui.battleStatsPanel.hide()
        @ui.cursor.moveTo(@playerTurn.selectedUnit.pos)
        @ui.controlState = new CsActionMenu(@ui, @ui.actionMenu)

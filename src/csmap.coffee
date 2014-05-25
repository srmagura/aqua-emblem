class window.CsMap extends ControlState

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

class window.CsChooseTarget extends CsMap

    constructor: (@ui, @playerTurn) ->

    f: ->
        target = @ui.chapter.getUnitAt(@ui.cursor.pos)

        if target isnt null and target in @playerTurn.inRange
            @playerTurn.battle = new Battle(@ui,
                @playerTurn.selectedUnit, target)

            @ui.weaponMenu.init(@playerTurn)
            @ui.battleStatsPanel.init(@playerTurn.battle)

    d: ->
        @ui.actionMenu.show()
        @ui.controlState = new CsActionMenu(@ui, @ui.actionMenu)
        @ui.cursor.moveTo(@playerTurn.selectedUnit.pos)

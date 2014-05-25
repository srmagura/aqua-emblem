window.VICTORY_CONDITION = {
    ROUT: {text: 'Defeat all enemies'}
}

class window.Chapter
    
    constructor: (@ui, @map, @playerTeam, @enemyTeam, @victoryCondition) ->
        @done = false
        @initUnits()

        @playerTurn = new PlayerTurn(@ui)
        @enemyTurn = new EnemyTurn(@ui)

    initUnits: ->
        @units = []
        for unit, k in @playerTeam.units
            unit.pos = @map.playerPositions[k]
            @units.push(unit)
            unit.team = @playerTeam

        for unit in @enemyTeam.units
            @units.push(unit)
            unit.team = @enemyTeam

        for unit in @units
            unit.hp = unit.baseHp

            if unit.baseMp?
                unit.mp = unit.baseMp

            unit.ui = @ui

    getUnitAt: (pos) ->
        for unit in @units
            if unit.pos.equals(pos)
                return unit

        null

    kill: (unit) ->
        removeFrom = (array) ->
            for u, k in array
                if u is unit
                    array.splice(k, 1)
                    break

        removeFrom(@units)
        removeFrom(unit.team.units)

        if unit.lord
            @defeat()
            return false

        return not @checkConditions()

    checkConditions: ->
        victory = false

        if @victoryCondition == VICTORY_CONDITION.ROUT
            victory = (@enemyTeam.units.length == 0)

        if victory
            @ui.messageBox.showVictoryMessage()
            @ui.unitInfoBox.hide()
            @done = true
            return true
        else
            return false

    defeat: ->
        @done = true
        @ui.unitInfoBox.hide()
        @ui.messageBox.showDefeatMessage()

    initTurn: (team) ->
        for unit in @units
            unit.done = false

        @ui.controlState = new ControlState(@ui)
        if team == @enemyTeam
            @ui.cursor.visible = false

        callback = (team) =>
            if team is @enemyTeam
                @enemyTurn.doTurn()
            else
                @ui.controlState = new CsMap(@ui)
                @ui.cursor.visible = true

        @ui.messageBox.showPhaseMessage(team, callback)

    checkAllDone: ->
        allDone = true

        for unit in @playerTeam.units
            if not unit.done
                allDone = false
                break

        if allDone
            @initTurn(@enemyTeam)

    getUnitAt: (pos) ->
        for unit in @units
            if unit.pos.equals(pos)
                return unit

        null

    render: (ui, ctx) ->
        @map.render(ui, ctx)
        if @playerTurn.dest?
            @playerTurn.dest.render(ui, ctx)

        for unit in @units
            unit.render(ui, ctx)

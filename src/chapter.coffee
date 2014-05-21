window.VC = {
    ROUT: {text: 'Defeat all enemies'}
}

class window.Chapter
    
    constructor: (@ui, @map, @playerTeam, @enemyTeam, @victoryCondition) ->
        @done = false

        @initUnits()
        #@initTurn(@playerTeam)

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
            unit.mp = unit.baseMp

    checkConditions: ->
        victory = false

        if @victoryCondition == VC_ROUT
            victory = (@enemyTeam.units.length == 0)

        if victory
            @ui.messageBox.showVictoryMessage()
            @ui.unitInfoBox.update()
            @done = true
            return true
        else
            return false

    defeat: ->
        @done = true
        #showDefeatMessage()
        #hideUnitInfoBox()

    initTurn: (team) ->
        for unit in @units
            unit.done = false

        @ui.controlState = ControlState
        if team == @enemyTeam
            @ui.cursor.visible = false

        callback = (team) ->
            if team is @teamEnemy
                @ui.controlState = ControlState
                #doEnemyTurn()
            else
                @ui.controlState = CsMap
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

        for unit in @units
            unit.render(ui, ctx)


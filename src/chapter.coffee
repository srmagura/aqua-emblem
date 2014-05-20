class window.Chapter
    @VC_ROUT: 0
    @victoryConditionText: {
        @VC_ROUT: 'Defeat all enemies'
    }
    
    constructor: (@map, @playerTeam, @enemyTeam, @victoryCondition) ->
        @done = false
        $('.victory-condition').text(
            @victoryConditionText[@victoryCondition])

        @initUnits()
        @initTurn(@playerTeam)

    initUnits: ->
        @units = []
        for unit in @playerTeam.units
            unit.pos = @map.playerPositions[k]
            @units.push(unit)
            unit.team = @playerTeam

        for unit in @enemyTeam.units
            @units.push(unit)
            unit.team = @enemyTeam

        for unit in @unit
            unit.hp = unit.baseHp
            unit.mp = unit.baseMp

    checkConditions: ->
        victory = false

        if @victoryCondition == VC_ROUT
            victory = (@enemyTeam.units.length == 0)

        if victory
            #showVictoryMessage()
            #updateUnitInfoBox()
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
            @cursor.visible = false

        callback = (team) ->
            if team is @teamEnemy
                @ui.controlState = ControlState
                #doEnemyTurn()
            else
                @ui.controlState = CsMap
                @cursor.visible = true

        @ui.messageBox.showPhaseMessage(team, callback)

    checkAllDone: ->
        allDone = true

        for unit in @playerTeam.units
            if not unit.done
                allDone = false
                break

        if allDone
            @initTurn(@enemyTeam)

_map.VICTORY_CONDITION = {
    ROUT: {text: 'Defeat all enemies'}
}

class _map.Chapter
    
    constructor: (@ui, @map) ->
        @done = false
        @map.ui = @ui
        @playerTurn = new _turn.PlayerTurn(@ui)
        @enemyTurn = new _turn.EnemyTurn(@ui)
        
        @turnIndex = 0
        
    setPlayerTeam: (@playerTeam) ->
        @initUnits()

    initUnits: ->
        @units = []
        for unit, k in @playerTeam.units
            unit.pos = @map.playerPositions[k]
            @units.push(unit)
            unit.team = @playerTeam

            bonus = @ui.file.difficulty.statBonus
            for stat of unit.startStats
                if stat != 'move'
                    unit.startStats[stat] += bonus

            unit.calcStatsInitial()

        for unit in @enemyTeam.units
            @units.push(unit)
            unit.team = @enemyTeam

        for unit in @units
            unit.ui = @ui
            unit.calcCombatStats()
            
    addUnit: (team, unit) ->
        @units.push(unit)
        team.units.push(unit)

    getUnitAt: (pos) ->      
        for unit in @units        
            if unit.pos.equals(pos)
                return unit

        return null

    kill: (unit) ->
        removeFrom = (array) ->
            for u, k in array
                if u is unit
                    array.splice(k, 1)
                    break

        removeFrom(@units)
        removeFrom(unit.team.units)

        if unit.team instanceof _team.PlayerTeam
            @defeat()
            return false

        return not @checkConditions()

    checkConditions: ->
        victory = false

        if @victoryCondition == _map.VICTORY_CONDITION.ROUT
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

        @ui.controlState = new _cs.cui.Chapter(@ui)

        callback = =>
            if not (doneFlags.scroll and doneFlags.phaseMessage)
                return
        
            if team is @enemyTeam
                @enemyTurn.doTurn()
            else
                if not @ui.cursor.pos?
                    for unit in team.units
                        if unit.id == 'ace'
                            @ui.cursor.moveTo(unit.pos)
                            break

                @ui.cursor.visible = true
                @ui.cursor.moveTo(@ui.cursor.pos)

                @ui.controlState = new _cs.cui.Map(@ui)
                
        doneFlags = {scroll: false, phaseMessage: false}
                
        if team instanceof _team.PlayerTeam
            @turnIndex++
        
            if @ui.cursor.pos? and not @ui.onScreen(@ui.cursor.pos)
                @ui.scrollTo(@ui.cursor.pos, =>
                    doneFlags.scroll = true
                    callback()
                )
            else
                doneFlags.scroll = true

            for unit in @units
                unit.onNewTurn()
        else
            @ui.cursor.visible = false
            @ui.unitInfoBox.hide()
            @ui.terrainBox.hide()
            doneFlags.scroll = true
            
            for unit in @units
                unit.onEnemyTurn()

        @ui.messageBox.showPhaseMessage(team, =>
            doneFlags.phaseMessage = true
            callback()
        )

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

        return null

    render: (ui, ctx) ->
        @map.render(ui, ctx)
        if @playerTurn.dest?
            @playerTurn.dest.render(ui, ctx)

        for unit in @units
            unit.render(ui, ctx)

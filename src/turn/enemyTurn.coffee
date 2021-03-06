class _turn.EnemyTurn extends _turn.Turn

    doTurn: ->
        @team = @ui.chapter.enemyTeam
        eu = @team.units
        @doUnitTurn(eu[0]) #may be undefined

    doUnitTurn: (unit) ->
        if not unit?
            @spawnReinforcements()
            return

        eu = @team.units
        @nextUnit = eu[eu.indexOf(unit)+1]

        if unit.aiType == _unit.aiType.halt
            available = [new _map.Destination(unit.pos, [unit.pos])]
        else
            available0 = @getAvailable(unit)

            available = []
            for avail in available0
                unitAt = @ui.chapter.getUnitAt(avail.pos)

                if unitAt is null or unitAt is unit
                    available.push(avail)

        attackRange = @movementGetAttackRange(available, unit)

        inRange = []
        for obj in attackRange
            unit1 = @ui.chapter.getUnitAt(obj.targetSpot)
            unit2 = @ui.chapter.getUnitAt(obj.moveSpot)

            if (unit2 is null or unit2 is unit) and
            unit1 != null and unit1.team is @ui.chapter.playerTeam
                inRange.push({
                    moveSpot: obj.moveSpot,
                    path: obj.path,
                    target: unit1
                })

        afterScroll = =>
            target = selectedInRange.target
            moveSpot = selectedInRange.moveSpot

            if not @ui.onScreen(moveSpot) or
            not @ui.onScreen(target.pos)
                @ui.scrollTo(moveSpot, =>
                    @scrollToMoveSpotDone = true
                    afterMove()
                )
            else
                @scrollToMoveSpotDone = true

            @battle = new _enc.Battle(@ui, unit, target,
                moveSpot.distance(target.pos))
            unit.followPath(selectedInRange.path, =>
                @followPathDone = true
                afterMove()
            )
            
        @scrollToMoveSpotDone = false
        @followPathDone = false
        
        afterMove = =>
            if @scrollToMoveSpotDone and @followPathDone
                @battle.doEncounter(@afterBattle)

        if inRange.length != 0
            selectedInRange = @chooseTarget(unit, inRange)

            if not @ui.onScreen(unit.pos)
                @ui.scrollTo(unit.pos, afterScroll)
            else
                afterScroll()
        else
            if unit.aiType is _unit.aiType.aggressive and
            ('startTurn' not of unit.aiOptions or
            @ui.chapter.turnIndex >= unit.aiOptions.startTurn)
                @doAdvance(unit)
            else
                @doUnitTurn(@nextUnit)
    
    afterExpAdd: =>
        setTimeout((=> @doUnitTurn(@nextUnit)), 250/@ui.speedMultiplier)

    chooseMaxDmg: (list) ->
        max = -1
        for obj in list
            if obj.maxDmg > max
                max = obj.maxDmg
                maxObj = obj

        return maxObj

    chooseTarget: (enemy, inRange) ->
        noRetaliate = []

        for obj in inRange
            target = obj.target
            range = obj.moveSpot.distance(target.pos)
            battle = new _enc.Battle(@ui, enemy, target, range)
            obj.maxDmg = battle.nTurns.atk * enemy.battleStats.dmg

            # Try to kill player if there's a chance
            if obj.maxDmg >= target.hp
                return obj

            if battle.nTurns.def == 0
                noRetaliate.push(obj)

        if noRetaliate.length != 0
            return @chooseMaxDmg(noRetaliate)

        return @chooseMaxDmg(inRange)

    doAdvance: (unit) ->
        available = @getAvailable(unit, {noLimit: true})
        attackRange = @movementGetAttackRange(available, unit)
        
        minDist = Infinity
        for obj in attackRange
            dist = unit.pos.distance(obj.moveSpot)          
            target = @ui.chapter.getUnitAt(obj.targetSpot)
            
            if target? and target.team instanceof _team.PlayerTeam and 
            dist < minDist
                fullPath = obj.path
                minDist = dist
       
        if fullPath.length-1 < unit.move
            i = fullPath.length-1
        else
            i = unit.move
         
        while true
            moveSpot = fullPath[i]
            path = fullPath.slice(0, i+1)
            i--
            
            unitAt = @ui.chapter.getUnitAt(moveSpot)           
            if not unitAt?
                break
                
            if i < 0
                @doUnitTurn(@nextUnit)
                return
        
        
        afterScroll = =>
            if not @ui.onScreen(moveSpot)
                @ui.scrollTo(moveSpot, ->)

            unit.followPath(path, => @doUnitTurn(@nextUnit))

        if not @ui.onScreen(unit.pos)
            @ui.scrollTo(unit.pos, afterScroll)
        else
            afterScroll()
            
    spawnUnit: (toAdd, i) ->
        if i == toAdd.length
            @doStatus()
            return 
    
        unit = toAdd[i]
        
        if @ui.chapter.getUnitAt(unit.pos)?
            @spawnUnit(toAdd, i+1)
            return
        
        afterScroll = =>
            @ui.chapter.addUnit(@team, unit)
            setTimeout((=> @spawnUnit(toAdd, i+1)),
                750/@ui.speedMultiplier)

        if not @ui.onScreen(unit.pos)
            @ui.scrollTo(unit.pos, afterScroll)
        else
            afterScroll()
            
    spawnReinforcements: ->
        toAdd = []
        turnIndex = @ui.chapter.turnIndex
        
        for unit in @team.reinforcements
            if unit.spawnTurn == turnIndex
                unit.ui = @ui
                toAdd.push(unit)
        
        @spawnUnit(toAdd, 0)
        
    doStatus: ->
        poisoned = []
        
        for unit in @team.units
            if unit.hasStatus(_status.Poison)
                poisoned.push(unit)
                
        i = 0
        unit = null
        
        callback = =>
            keepGoing = true
            if unit.hp == 0
                keepGoing = @ui.chapter.kill(unit)
                
            if keepGoing
                i++
                doPoison()
        
        doPoison = =>
            if i == poisoned.length
                @calcCombatStats()
                return
            
            unit = poisoned[i]
            action = new _status.PoisonAction()
            delta = {hp: -unit.getStatus(_status.Poison).dmg}
            
            unitAction = new _enc.UnitAction(@ui, unit)
            unitAction.doAction(action, callback, delta)
        
        doPoison()
        
    calcCombatStats: ->  
        for unit in @team.units
            unit.calcCombatStats()
            
        @ui.chapter.initTurn(@ui.chapter.playerTeam)
        


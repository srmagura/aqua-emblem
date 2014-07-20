class _turn.EnemyTurn extends _turn.Turn

    doTurn: ->
        eu = @ui.chapter.enemyTeam.units
        if eu.length != 0
            @doUnitTurn(eu[0])

    doUnitTurn: (unit) ->
        if not unit?
            @ui.chapter.initTurn(@ui.chapter.playerTeam)
            return

        eu = @ui.chapter.enemyTeam.units
        @nextUnit = eu[eu.indexOf(unit)+1]

        if unit.aiType == _unit.AI_TYPE.HALT
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
                @ui.scrollTo(moveSpot, ->)

            unit.followPath(selectedInRange.path, =>
                @battle = new _enc.Battle(@ui, unit, target)
                @battle.doEncounter(@afterBattle)
            )

        if inRange.length != 0
            selectedInRange = @chooseTarget(unit, inRange)

            if not @ui.onScreen(unit.pos)
                @ui.scrollTo(unit.pos, afterScroll)
            else
                afterScroll()
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


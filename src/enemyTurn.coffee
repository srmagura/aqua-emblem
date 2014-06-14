class window.EnemyTurn extends Turn

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

        if unit.aiType == AI_TYPE.HALT
            available = [new Destination(unit.pos, [unit.pos])]
        else
            available0 = @getAvailable(unit)

            available = []
            for avail in available0
                unitAt = @ui.chapter.getUnitAt(avail.pos)

                if unitAt is null
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
            if not @ui.onScreen(inRange[0].moveSpot) or
            not @ui.onScreen(target.pos)
                @ui.scrollTo(inRange[0].moveSpot, ->)

            unit.followPath(inRange[0].path, =>
                @battle = new Battle(@ui, unit, target)
                @battle.doBattle(@afterBattle)
            )

        if inRange.length != 0
            target = inRange[0].target

            if not @ui.onScreen(unit.pos)
                @ui.scrollTo(unit.pos, afterScroll)
            else
                afterScroll()
        else
            @doUnitTurn(@nextUnit)

    
    afterExpAdd: =>
        setTimeout((=> @doUnitTurn(@nextUnit)), 250)


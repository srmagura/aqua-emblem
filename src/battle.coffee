class window.Battle

    constructor: (@ui, @atk, @def) ->
        @range = @atk.pos.distance(@def.pos)
        @atk.calcCombatStats()
        @def.calcCombatStats()
        @calcBattleStats()

    calcBattleStats: ->
        @atk.advantage = null
        @def.advantage = null

        @calcIndividual(@atk, @def)
        @calcIndividual(@def, @atk)

        @turns = [@atk]
        @nTurns = {atk: 1, def: 0}

        if @range in @def.equipped.range
            @turns.push(@def)
            @nTurns.def++

        if @atk.attackSpeed - 4 > @def.attackSpeed
            @turns.push(@atk)
            @nTurns.atk++
        else if @def.attackSpeed - 4 > @atk.attackSpeed
            @turns.push(@def)
            @nTurns.def++

    calcIndividual: (unit1, unit2) ->
        w1 = unit1.equipped
        w2 = unit2.equipped

        if (w1 instanceof item.Sword and w2 instanceof item.Axe) or
        (w1 instanceof item.Axe and w2 instanceof item.Lance) or
        (w1 instanceof item.Lance and w2 instanceof item.Sword)
            unit1.advantage = true
            unit2.advantage = false

        unit1.battleStats ={}

        if @range not in w1.range
            return

        unit1.battleStats.hit = unit1.hit - unit2.evade
        unit1.battleStats.dmg = unit1.str + w1.might - unit2.def
        unit1.battleStats.crt = unit1.crit - unit2.critEvade

        if unit1.advantage is true
            factor = 1
        else if unit1.advantage is false
            factor = -1
        else
            factor = 0

        unit1.battleStats.hit += factor * 15
        unit1.battleStats.dmg += factor * 1

        for key, value of unit1.battleStats
            if value < 0
                unit1.battleStats[key] = 0
            if (key is 'hit' or key is 'crt') and value > 100
                unit1.battleStats[key] = 100

    doBattle: (@callback) ->
        @container = $(document.createElement('div'))
        @container.addClass('battle-unit-info-container').
        appendTo('.canvas-container')

        atkBoxEl = $('.sidebar .unit-info').clone()
        defBoxEl = $('.sidebar .unit-info').clone()

        if @atk.team is @ui.chapter.playerTeam
            @leftBox = atkBoxEl
            @rightBox = defBoxEl

            @leftUnit = @atk
            @rightUnit = @def
        else
            @leftBox = defBoxEl
            @rightBox = atkBoxEl
            @leftUnit = @def
            @rightUnit = @atk

        @container.append(@leftBox).append(@rightBox)

        @atkBox = new UnitInfoBox(@ui, atkBoxEl)
        @atkBox.populate(@atk, false)
        @atkBox.show()

        @defBox = new UnitInfoBox(@ui, defBoxEl)
        @defBox.populate(@def, false)
        @defBox.show()

        @midpoint = @atk.pos.add(@def.pos).scale(.5)

        tw = @ui.tw

        left = @midpoint.j*tw - @leftBox.width() + 15 - @ui.origin.j

        if @atk.pos.i > @def.pos.i
            maxI = @atk.pos.i
        else
            maxI = @def.pos.i

        top = (maxI + 1)*tw - @ui.origin.i
        @container.css({left: left, top: top})

        @turnIndex = 0
        @delay = 1500

        setTimeout(@doAttack, @delay/5)

    getOther: (unit) ->
        if unit is @atk
            return @def
        if unit is @def
            return @atk

    doAttack: =>
        callMade = false
        giver = @turns[@turnIndex]
        recvr = @getOther(giver)
        @doLunge(giver)

        randHit = 100*Math.random()
        if randHit < giver.battleStats.hit

            randCrit = 100*Math.random()
            if randCrit < giver.battleStats.crt
                @displayMessage(recvr, 'crit')
                recvr.hp -= 3*giver.battleStats.dmg
            else
                recvr.hp -= giver.battleStats.dmg
        else
            @displayMessage(recvr, 'miss')

        if recvr.hp <= 0
            recvr.hp = 0

            setTimeout(@battleDone, @delay)
            callMade = true

        @turnIndex++
        if not callMade
            if @turnIndex == @turns.length
                setTimeout(@battleDone, @delay)
            else
                setTimeout(@doAttack, @delay)

        @atkBox.populate(@atk, true)
        @defBox.populate(@def, true)

    doLunge: (unit) =>
        reverse = =>
            unit.direction = unit.direction.scale(-1)
            setTimeout(halt, @delay/3)

        halt = =>
            unit.direction = null
            unit.offset = new Position(0, 0)

        other = @getOther(unit)
        unit.direction = other.pos.subtract(unit.pos).toUnitVector()
        unit.movementSpeed = .025

        setTimeout(reverse, @delay/3)

    battleDone: =>
        keepGoing = true
        @container.remove()

        if @atk.hp == 0
            keepGoing = @ui.chapter.kill(@atk)
        if @def.hp == 0
            keepGoing = @ui.chapter.kill(@def)

        if(keepGoing and @callback?)
            @callback()

    displayMessage: (overUnit, mtype) ->
        el = $('<div class="battle-message"></div>')
        el.addClass(mtype)
        tw = @ui.tw

        if mtype is 'miss'
            el.text('Miss')
        else if mtype is 'crit'
            el.text('Crit!')
        
        top = overUnit.pos.i*tw - ui.origin.i
        left = overUnit.pos.j*tw + tw/2 - el.width()/2 - ui.origin.j
        el.appendTo($('.canvas-container')).css({top: top, left: left})

        el.fadeIn(@delay/5)

        startFadeOut = =>
            el.fadeOut(@delay/5)
            el.remove()

        setTimeout(startFadeOut, 3*@delay/5)


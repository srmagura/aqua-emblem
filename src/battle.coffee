class window.Battle

    constructor: (@ui, @atk, @def) ->
        @range = @atk.pos.distance(@def.pos)
        @atk.calcCombatStats()
        @def.calcCombatStats()
        @calcBattleStats()

    calcBattleStats: (playerWeapon) ->
        if playerWeapon?
            @calcIndividual(@atk, playerWeapon, @def)
        else
            @calcIndividual(@atk, @atk.equipped, @def)

        @calcIndividual(@def, @def.equipped, @atk)

        if @range in @def.equipped.range
            @turns = [@atk, @def]
        else
            @turns = [@atk]

    calcIndividual: (unit1, weapon1, unit2) ->
        unit1.battleStats ={}

        if @range not in weapon1.range
            return

        unit1.battleStats.hit = unit1.hit - unit2.evade
        unit1.battleStats.dmg = unit1.str + weapon1.might - unit2.def
        unit1.battleStats.crt = unit1.crit - unit2.critEvade

        for key, value of unit1.battleStats
            if value < 0
                unit1.battleStats[key] = 0
            if (key is 'hit' or key is 'crt') and value > 100
                unit1.battleStats[key] = 100

    setPlayerWeapon: (weapon) ->
        @calcBattleStats(weapon)

    doBattle: (@callback) ->
        @container = $(document.createElement('div'))
        @container.addClass('battle-unit-info-container').appendTo('body')

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

        @cpos = @ui.canvas.position()
        @midpoint = @atk.pos.add(@def.pos).scale(.5)

        tw = @ui.tw

        #magic number...
        left = @midpoint.j*tw + @cpos.left - @leftBox.width() + 15

        if @atk.pos.i > @def.pos.i
            maxI = @atk.pos.i
        else
            maxI = @def.pos.i

        top = (maxI + 1)*tw + @cpos.top
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
        
        top = @cpos.top + overUnit.pos.i*tw
        left = @cpos.left + overUnit.pos.j*tw + tw/2 - el.width()/2
        el.appendTo($('body')).css({top: top, left: left})

        el.fadeIn(@delay/5)

        startFadeOut = =>
            el.fadeOut(@delay/5)
            el.remove()

        setTimeout(startFadeOut, 3*@delay/5)


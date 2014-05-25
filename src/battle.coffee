class window.Battle

    constructor: (@ui, @atk, @def) ->
        @calcBattleStats()

    calcBattleStats: (playerWeapon) ->
        if playerWeapon?
            @calcIndividual(@atk, playerWeapon, @def)
        else
            @calcIndividual(@atk, @atk.equipped, @def)

        @calcIndividual(@def, @def.equipped, @atk)
        @turns = [@atk, @def]

    calcIndividual: (unit1, weapon1, unit2) ->
        unit1.battleStats = {hit: 100}
        unit1.battleStats.dmg = unit1.str + weapon1.might - unit2.def
        unit1.battleStats.crt = 0

    setPlayerWeapon: (weapon) ->
        @calcBattleStats(weapon)

    doBattle: (@callback) ->
        @container = $(document.createElement('div'))
        @container.addClass('battle-unit-info-container').appendTo('body')

        atkBoxEl = $('.sidebar .unit-info').clone()
        defBoxEl = $('.sidebar .unit-info').clone()

        if @atk.team is @ui.chapter.playerTeam
            @container.append(atkBoxEl).append(defBoxEl)
        else
            @container.append(defBoxEl).append(atkBoxEl)

        @atkBox = new UnitInfoBox(@ui, atkBoxEl)
        @atkBox.populate(@atk, false)
        @atkBox.show()

        @defBox = new UnitInfoBox(@ui, defBoxEl)
        @defBox.populate(@def, false)
        @defBox.show()

        cpos = @ui.canvas.position()
        midpoint = @atk.pos.add(@def.pos)

        tw = @ui.tw
        left = midpoint.j*tw/2 + cpos.left - defBoxEl.width()
        top = midpoint.i*tw/2 + 1.5*tw + cpos.top
        @container.css({left: left, top: top})

        @turnIndex = 0
        @delay = 500

        setTimeout(@doAttack, @delay)

    getOther: (unit) ->
        if unit is @atk
            return @def
        if unit is @def
            return @atk

    doAttack: =>
        callMade = false
        giver = @turns[@turnIndex]
        recvr = @getOther(giver)

        recvr.hp -= giver.battleStats.dmg
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

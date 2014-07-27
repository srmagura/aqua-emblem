class _enc.Battle extends _enc.Encounter

    constructor: (@ui, @atk, @def, @dist=null) ->
        if not @dist?
            @dist = @atk.pos.distance(@def.pos)

        @mpTaken = false

        @atk.calcCombatStats()
        @def.calcCombatStats()
        @calcBattleStats()

    calcBattleStats: ->
        @atk.advantage = null
        @def.advantage = null

        @calcAdvantage(@atk, @def)
        @calcAdvantage(@def, @atk)

        @calcIndividual(@atk, @def)
        @calcIndividual(@def, @atk)

        @turns = [@atk]
        @nTurns = {atk: 1, def: 0}

        defCanAttack = (@def.equipped? and
        @def.equipped.range.contains(@dist) and
        not @def.hasStatus(_status.Defend))

        if defCanAttack
            @turns.push(@def)
            @nTurns.def++

        if(@atk.attackSpeed - 4 > @def.attackSpeed and
        @atk.equipped.hasUses(2))
            @turns.push(@atk)
            @nTurns.atk++
            
        else if(defCanAttack and
        @def.attackSpeed - 4 > @atk.attackSpeed and
        @def.equipped.hasUses(2))    
            @turns.push(@def)
            @nTurns.def++

        @attacksHit = 0

    calcAdvantage: (unit1, unit2) ->
        if not (unit1.equipped? and unit2.equipped?)
            return
    
        t1 = unit1.equipped.type
        t2 = unit2.equipped.type

        Sword = _skill.type.Sword
        Lance = _skill.type.Lance
        Axe = _skill.type.Axe

        if (t1 instanceof Sword and t2 instanceof Axe) or
        (t1 instanceof Axe and t2 instanceof Lance) or
        (t1 instanceof Lance and t2 instanceof Sword)
            unit1.advantage = true
            unit2.advantage = false

    calcIndividual: (unit1, unit2) ->
        w1 = unit1.equipped
        if not w1?
            return
        
        unit1.battleStats ={}

        if not w1.range.contains(@dist)
            return

        if w1.type instanceof _skill.type.Physical
            strOrMag = unit1.str
            defOrRes = unit2.def
        else if w1.type instanceof _skill.type.Magic
            strOrMag = unit1.mag
            defOrRes = unit2.res

        unit1.battleStats.hit = unit1.hit - unit2.evade
        unit1.battleStats.dmg = strOrMag + w1.might - defOrRes
        unit1.battleStats.crt = unit1.crit - unit2.critEvade

        if unit1.advantage is true
            factor = 1
        else if unit1.advantage is false
            factor = -1
        else
            factor = 0

        unit1.battleStats.hit += factor * 15
        unit1.battleStats.dmg += factor * 1

        if unit2.hasStatus(_status.Defend)
            unit1.battleStats.dmg = Math.round(unit1.battleStats.dmg/2)

        for key, value of unit1.battleStats
            if value < 0
                unit1.battleStats[key] = 0
            if (key is 'hit' or key is 'crt') and value > 100
                unit1.battleStats[key] = 100

    getPlayerUnit: ->
        if @atk.team instanceof _team.PlayerTeam
            return @atk
        else
            return @def

    getEnemyUnit: ->
        @getOther(@getPlayerUnit())

    doAction: =>
        callMade = false
        giver = @turns[@turnIndex]
        recvr = @getOther(giver)
        @doLunge(giver)

        randHit = 100*Math.random()
        if randHit < giver.battleStats.hit
            dmg = giver.battleStats.dmg
            randCrit = 100*Math.random()

            if randCrit < giver.battleStats.crt
                @displayMessage(recvr, 'crit')
                dmg *= 3

            recvr.hp -= dmg

            if dmg == 0
                @displayMessage(recvr, 'no-dmg')

            if giver is @getPlayerUnit()
                if giver.equipped.mp?
                    if not @mpTaken
                        giver.mp -= giver.equipped.mp
                        @mpTaken = true
                else if giver.mp < giver.maxMp
                    giver.mp++
                    
                    if giver.equipped.uses?
                        giver.equipped.uses--

                @attacksHit++
                
        else
            @displayMessage(recvr, 'miss')

        if recvr.hp <= 0
            recvr.hp = 0

            setTimeout(@encounterDone, @delay)
            callMade = true

        @turnIndex++
        if not callMade
            if @turnIndex == @turns.length
                setTimeout(@encounterDone, @delay)
            else
                setTimeout(@doAction, @delay)

        @atkBox.init(@atk, true)
        @defBox.init(@def, true)

    showSkillMessage: (skill) ->
        afterFadeIn = =>
            setTimeout(afterDelay, @delay*5/6)

        afterDelay = =>
            @message.fadeOut(@delay/6)

        @message = skill.getMessageEl()
        @message.addClass('blue-box').appendTo(@container)
        @message.hide().fadeIn(@delay/6, afterFadeIn)

    encounterDone: =>
        super(false)

        pu = @getPlayerUnit()
        if pu.equipped? and pu.equipped.uses == 0
            item = pu.equipped
            pu.inventory.remove(item)
            @ui.messageBox.showBrokenMessage(item, @afterWeaponBreak)
        else
            @afterWeaponBreak()
                
    afterWeaponBreak: =>
        pu = @getPlayerUnit()
        eu = @getEnemyUnit()       
        doDrop = false
        
        if eu.hp == 0
            for item in eu.inventory.it()
                if item.drop
                    eu.inventory.remove(item)
                    doDrop = true
                    @ui.staticTurn.doReceiveItem(pu, item, @afterWeaponBreak)
                    break  
                                     
        if not doDrop
            @afterReceiveItem()
            
    afterReceiveItem: =>
        keepGoing = true
        
        if @atk.hp == 0
            keepGoing = @ui.chapter.kill(@atk)
        if @def.hp == 0
            keepGoing = @ui.chapter.kill(@def)

        if keepGoing
            @callback()

    getExpToAdd: ->
        player = @getPlayerUnit()
        enemy = @getEnemyUnit()

        levelDif = enemy.level - player.level

        if @attacksHit > 0
            dmgExp = .10 + levelDif/100
        else
            dmgExp = .01

        defeatExp = 0
        if enemy.hp == 0
            defeatExp = .25 + levelDif/100

        exp = dmgExp + defeatExp
        exp *= ui.expMultiplier

        if exp > 1
            ceil = 1
        else
            ceil = exp

        return ceil

    displayMessage: (overUnit, mtype) ->
        el = $('<div class="battle-message"></div>')
        el.addClass(mtype)
        tw = @ui.tw

        if mtype is 'miss'
            el.text('MISS')
        else if mtype is 'crit'
            el.text('CRIT!')
        else if mtype is 'no-dmg'
            el.text('NO DMG')
        
        top = overUnit.pos.i*tw - ui.origin.i
        left = overUnit.pos.j*tw + tw/2 - el.width()/2 - ui.origin.j
        el.appendTo($('.canvas-container')).css({top: top, left: left})

        el.fadeIn(@delay/5)

        startFadeOut = =>
            el.fadeOut(@delay/5)
            el.remove()

        setTimeout(startFadeOut, 3*@delay/5)

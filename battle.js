function Battle(attacker, defender){
    this.getOther = function(unit){
        if(unit == this.attacker){
            return this.defender
        } else {
            return this.attacker
        }
    }

    function calcBattleStatsIndividual(unit1, weapon1, unit2){
        unit1.battleStats = {hit: 100}
        unit1.battleStats.dmg = unit1.str + weapon1.might - unit2.def
    }

    this.calcBattleStats = function(playerWeapon){
        if(playerWeapon){
            calcBattleStatsIndividual(
                this.attacker, playerWeapon, this.defender)
        } else {
            calcBattleStatsIndividual(
                this.attacker, this.attacker.equipped,
                this.defender)
        }

        calcBattleStatsIndividual(this.defender, 
            this.defender.equipped, this.attacker)

        this.turns = [this.attacker, this.defender]
    }

    this.setPlayerWeapon = function(weapon){
        this.calcBattleStats(weapon) 
    }

    this.attacker = attacker
    this.defender = defender
    this.calcBattleStats()
}

function doBattle(callback){
    var container = $(document.createElement('div'))
    container.addClass('battle-unit-info-container').
        appendTo('body')

    attackerBox = $('.unit-info').clone().css('visibility', 'visible')
    defenderBox = $('.unit-info').clone().css('visibility', 'visible')

    if(battle.attacker.team == TEAM_PLAYER){
        container.append(attackerBox).append(defenderBox)
    } else {
        container.append(defenderBox).append(attackerBox)
    }

    populateUnitInfoBox(defenderBox, battle.defender)
    populateUnitInfoBox(attackerBox, battle.attacker)


    var cpos = $('canvas').position()
    var midpoint = posAdd(battle.attacker.pos, battle.defender.pos)

    var left = midpoint[1]*tw/2 + cpos.left - defenderBox.width()
    var top = midpoint[0]*tw/2 + 1.5*tw + cpos.top
    container.css({left: left, top: top})

    var turnIndex = 0 
    var delay = 500

    function doAttack(){
        var callMade = false
        var giver = battle.turns[turnIndex]
        var recvr = battle.getOther(giver)

        recvr.hp -= giver.battleStats.dmg
        if(recvr.hp <= 0){
            recvr.hp = 0

            setTimeout(battleDone, delay)
            callMade = true
        }

        turnIndex++
        if(!callMade){
            if(turnIndex == battle.turns.length){
                setTimeout(battleDone, delay)
            } else {
                setTimeout(doAttack, delay)
            }
        }

        populateUnitInfoBox(attackerBox, battle.attacker, true)
        populateUnitInfoBox(defenderBox, battle.defender, true)
        updateUnitInfoBox()
    }

    function battleDone(){
        var keepGoing = true
        container.remove()

        if(battle.attacker.hp == 0)
            keepGoing = battle.attacker.die()
        if(battle.defender.hp == 0)
            keepGoing = battle.defender.die()

        if(keepGoing && battle.attacker.team == TEAM_PLAYER){
            controlState = csMap
            cursorVisible = true
            cursorPos = $.extend({}, battle.attacker.pos)
            cursorMoved()
            selectedUnit.setDone()
        }

        selectedUnit = null

        if(callback)
            callback()
    }

    setTimeout(doAttack, delay)
}


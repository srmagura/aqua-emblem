function Battle(attacker, defender){
    this.getOther = function(unit){
        if(unit == this.attacker)
            return this.defender
        else
            return this.attacker
    }

    function calcDmg(unit1, unit2){
        return unit1.str - unit2.def + 2
    }

    function calcBattleStats(unit1, unit2){
        unit1.battleStats = {hit: 100}
        unit1.battleStats.dmg = calcDmg(unit1, unit2)
    }

    this.attacker = attacker
    this.defender = defender
    
    calcBattleStats(this.attacker, this.defender)
    calcBattleStats(this.defender, this.attacker)

    this.turns = [this.attacker, this.defender]
}

function doBattle(){
    var container = $(document.createElement('div'))
    container.addClass('battle-unit-info-container')

    attackerBox = $('.unit-info').clone().css('visibility', 'visible')
    populateUnitInfoBox(attackerBox, battle.attacker)

    defenderBox = $('.unit-info').clone().css('visibility', 'visible')
    populateUnitInfoBox(defenderBox, battle.defender)

    if(battle.attacker.team == TEAM_PLAYER){
        container.append(attackerBox).append(defenderBox)
    } else {
        container.append(defenderBox).append(attackerBox)
    }

    $('body').append(container)

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

        populateUnitInfoBox(attackerBox, battle.attacker)
        populateUnitInfoBox(defenderBox, battle.defender)
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
    }

    setTimeout(doAttack, delay)
}


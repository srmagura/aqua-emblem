function Battle(attacker, defender){
    this.attacker = attacker
    this.defender = defender

    this.attacker.battleStats = {hit: 100, dmg: 5}
    this.defender.battleStats = {hit: 100, dmg: 2}

    this.getOther = function(unit){
        if(unit == this.attacker)
            return this.defender
        else
            return this.attacker
    }
}

function doBattle(){
    var container = $(document.createElement('div'))
    container.addClass('battle-unit-info-container')

    attackerBox = $('.unit-info').clone().css('visibility', 'visible')
    populateUnitInfoBox(attackerBox, battle.attacker)
    container.append(attackerBox)

    defenderBox = $('.unit-info').clone().css('visibility', 'visible')
    populateUnitInfoBox(defenderBox, battle.defender)
    container.append(defenderBox)

    $('body').append(container)

    var cpos = $('canvas').position()
    var midpoint = posAdd(battle.attacker.pos, battle.defender.pos)

    var left = midpoint[1]*tw/2 + cpos.left - defenderBox.width()
    var top = midpoint[0]*tw/2 + 1.5*tw + cpos.top
    container.css({left: left, top: top})

    battle.whoseTurn = battle.attacker 

    var delay = 350

    function doAttack(){
        var callMade = false
        var giver = battle.whoseTurn 
        var recvr = battle.getOther(giver)

        recvr.hp -= giver.battleStats.dmg
        if(recvr.hp <= 0){
            recvr.hp = 0

            setTimeout(battleDone, delay)
            callMade = true
        }

        if(!callMade){
            if(recvr.team == TEAM_ENEMY){
                battle.whoseTurn = recvr
                setTimeout(doAttack, delay)
            } else {
                setTimeout(battleDone, delay)
            }
        }

        populateUnitInfoBox(attackerBox, battle.attacker)
        populateUnitInfoBox(defenderBox, battle.defender)
    }

    function battleDone(){
        container.remove()

        if(battle.attacker.team == TEAM_PLAYER){
            controlState = csMap
            cursorVisible = true
            cursorPos = $.extend({}, battle.attacker.pos)
            cursorMoved()
            selectedUnit = null
        }

        if(battle.attacker.hp == 0)
            unitDeath(battle.attacker)
        if(battle.defender.hp == 0)
            unitDeath(battle.defender)
    }

    setTimeout(doAttack, delay)

}


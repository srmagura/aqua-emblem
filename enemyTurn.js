function doEnemyTurn(){
    doEnemyUnitTurn(0)
}

function doEnemyUnitTurn(k){
    if(chapter.done){
        return
    }

    if(k >= chapter.enemyTeam.units.length){
        chapter.initTurn(chapter.playerTeam)
        return
    }

    var unit = chapter.enemyTeam.units[k]
    var available = movementGetAvailable(unit)
    var attackRange = []

    for(var p = 0; p < available.length; p++){
        for(var l = 0; l < directions.length; l++){
            var alt = posAdd(available[p], directions[l])
            if(onMap(alt)){
                attackRange.push({
                    moveSpot: available[p],
                    targetSpot: alt
                })
            }
        }
    }

    inRange = []
    for(var l = 0; l < attackRange.length; l++){
        var unit1 = getUnitAt(attackRange[l].targetSpot)
        if(unit1 != null && unit1.team == TEAM_PLAYER){
            inRange.push({
                moveSpot: attackRange[l].moveSpot,
                target: unit1
            })
        }
    }

    if(inRange.length != 0){
        unit.pos = $.extend({}, inRange[0].moveSpot)
        battle = new Battle(unit, inRange[0].target) 
        doBattle(function(){
            doEnemyUnitTurn(k+1)   
        })
    } else {
        doEnemyUnitTurn(k+1)   
    }
}

function doEnemyTurn(){
    var eu = chapter.enemyTeam.units
    if(eu.length != 0){
        doEnemyUnitTurn(eu[0])
    }
}

function doEnemyUnitTurn(unit){
    if(chapter.done){
        return
    }

    if(!unit){
        chapter.initTurn(chapter.playerTeam)
        return
    }

    var eu = chapter.enemyTeam.units
    var nextUnit = eu[eu.indexOf(unit)+1]
    var available

    if(unit.aiType == AI_HALT){
        available = [{pos: unit.pos, path: [unit.pos]}]
    } else {
        available = movementGetAvailable(unit)
    }
    var attackRange = []

    for(var p = 0; p < available.length; p++){
        for(var l = 0; l < directions.length; l++){
            var alt = posAdd(available[p].pos, directions[l])
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
        unit.followPath(inRange[0].moveSpot.path, function(){
            battle = new Battle(unit, inRange[0].target) 
            doBattle(function(){
                setTimeout(function(){
                    doEnemyUnitTurn(nextUnit)   
                }, 
                250)
            })
        })
    } else {
        doEnemyUnitTurn(nextUnit)   
    }
}

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
    var attackRange = []
    for(var l = 0; l < directions.length; l++){
        var alt = posAdd(unit.pos, directions[l])
        if(onMap(alt)){
            attackRange.push(alt)
        }
    }

    inRange = []
    for(var l = 0; l < attackRange.length; l++){
        var unit1 = getUnitAt(attackRange[l])
        if(unit1 != null && unit1.team == TEAM_PLAYER){
            inRange.push(unit1)
        }
    }

    if(inRange.length != 0){
        battle = new Battle(unit, inRange[0]) 
        doBattle(function(){
            doEnemyUnitTurn(k+1)   
        })
    } else {
        doEnemyUnitTurn(k+1)   
    }
}

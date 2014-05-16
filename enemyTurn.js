function doEnemyTurn(){
    for(var k = 0; k < chapter.enemyTeam.units.length; k++){
        doEnemyUnitTurn(chapter.enemyTeam.units[k])
    }

    chapter.initTurn(chapter.playerTeam)
}

function doEnemyUnitTurn(unit){
    var attackRange = []
    for(var k = 0; k < directions.length; k++){
        var alt = posAdd(unit.pos, directions[k])
        if(onMap(alt)){
            attackRange.push(alt)
        }
    }

    inRange = []
    for(var k = 0; k < attackRange.length; k++){
        var unit1 = getUnitAt(attackRange[k])
        if(unit1 != null && unit1.team == TEAM_PLAYER){
            inRange.push(unit1)
        }
    }

    if(inRange.length != 0){
        battle = new Battle(unit, inRange[0]) 
        doBattle()
    }
}

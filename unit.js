var TEAM_PLAYER = 0
var TEAM_ENEMY = 1

var playerUnits = [
    {name: 'Ace', move: 4, baseHp: 20}
]

var enemyUnits = [
    {name: 'Bandit', pos: [4, 2], baseHp: 14} 
]

var units = []

function initUnits(){
    for(var k = 0; k < playerUnits.length; k++){
        playerUnits[k].team = TEAM_PLAYER        
        playerUnits[k].pos = map.playerPositions[k]
        units.push(playerUnits[k])
    }

    for(var k = 0; k < enemyUnits.length; k++){
        enemyUnits[k].team = TEAM_ENEMY       
        units.push(enemyUnits[k])
    }

    for(var k = 0; k < units.length; k++){
        units[k].hp = units[k].baseHp
    }
}

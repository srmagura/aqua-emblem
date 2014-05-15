function initChapter(){
    var playerUnits = [
        {name: 'Ace', baseHp: 20, move: 4, str: 5, def: 2}
    ]
    var playerTeam = new Team(playerUnits, TEAM_PLAYER)

    var enemyUnits = [
        {name: 'Bandit', pos: [4, 2], baseHp: 14, move: 4, str: 2, def: 1} 
    ]
    var enemyTeam = new Team(enemyUnits, TEAM_ENEMY)

    var tiles = [
        [1, 1, 0, 1, 0, 0, 0],
        [1, 0, 0, 1, 0, 0, 0],
        [0, 0, 0, 1, 1, 0, 0],
        [0, 0, 0, 1, 1, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [1, 1, 0, 0, 0, 0, 0]
    ]
    var playerPositions = [[1, 1]]

    var map = new Map(tiles, playerPositions)
    chapter = new Chapter(map, playerTeam, enemyTeam, VC_ROUT)
}

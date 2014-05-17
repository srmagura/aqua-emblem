function initChapter(){
    var playerUnits = [
        new Unit({name: 'Ace', baseHp: 20, move: 4, str: 5, def: 2,
            lord: true}),
        new Unit({name: 'Shiina', baseHp: 16, move: 4, str: 7, def: 1}),
    ]
    var playerTeam = new Team(playerUnits, TEAM_PLAYER)

    var enemyUnits = [
        new Unit({name: 'Bandit', pos: [4, 2], baseHp: 14, 
            move: 4, str: 2, def: 1}),
        new Unit({name: 'Bandit', pos: [6, 4], baseHp: 14, 
            move: 4, str: 2, def: 1}),
        new Unit({name: 'Bandit', pos: [3, 5], baseHp: 14, 
            move: 4, str: 2, def: 1}),
        new Unit({name: 'Bandit lord', pos: [0, 5], aiType: AI_HALT,
            baseHp: 22, 
            move: 4, str: 4, def: 1})
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
    var playerPositions = [[1, 1], [2,0]]

    var map = new Map(tiles, playerPositions)
    chapter = new Chapter(map, playerTeam, enemyTeam, VC_ROUT)
}

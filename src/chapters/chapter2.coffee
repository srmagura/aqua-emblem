window._chapters = {}

class _chapters.Chapter2 extends _map.Chapter

    constructor: (@ui) ->     
        enemyUnits = [
            new _uclass.Fighter({pos: new Position(4, 2),
            name: 'Morgan', boss: true, picture: true,
            level: 7,
            items: [new _item.IronAxe()]}),
        ]

        @enemyTeam = new _team.EnemyTeam(enemyUnits, {defaultName: 'Bandit'})
        @enemyTeam.insigniaImagePath = 'images/bandit_insignia.png'

        terrainMapping = {
            0: _terrain.Plain
            1: _terrain.Rocks
            2: _terrain.Forest
        }

        tiles = [
            [0, 0, 0, 0,0,0,0,0,0,0,0,0],
            [0, 0, 0, 0,0,0,0,0,0,0,0,0],
            [0, 0, 0, 0,0,0,0,0,0,0,0,0],
            [0, 0, 0, 0,0,0,0,0,0,0,0,0],
            [0, 0, 0, 0,0,0,0,0,0,0,0,0],
            [0, 0, 0, 0,0,0,0,0,0,0,0,0],
            [0, 0, 0, 0,0,0,0,0,0,0,0,0],
            [0, 0, 0, 0,0,0,0,0,0,0,0,0],
            [0, 0, 0, 0,0,0,0,0,0,0,0,0],
            [0, 0, 0, 0,0,0,0,0,0,0,0,0],            
        ]

        playerPositions = [[2,1], [1,0], [0,1], [1, 2]]
        @origin0 = new Position(0, 4*@ui.tw)
        @victoryCondition = _map.VICTORY_CONDITION.ROUT
        
        map = new _map.Map(tiles, terrainMapping, playerPositions)
        super(@ui, map)

    doScrollSequence: (callback) ->
        #f = =>
        #    @ui.scrollTo(new Position(0, 0), callback, .07)

        #setTimeout(f, 1000/@ui.speedMultiplier)

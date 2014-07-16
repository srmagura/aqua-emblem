window._chapters = {}

class _chapters.Chapter1 extends _map.Chapter

    constructor: (@ui) ->     
        enemyUnits = [
            new _uclass.Fighter({pos: new Position(4, 2),
            level: 1,
            inventory: [new _item.IronAxe()]}),

            new _uclass.Fighter({pos: new Position(5, 4),
            level: 1,
            inventory: [new _item.IronAxe()]}),

            new _uclass.Archer({pos: new Position(8, 3),
            level: 1,
            inventory: [new _item.IronBow()]}),

            new _uclass.Soldier({pos: new Position(6, 5),
            level: 2, aiType: _unit.AI_TYPE.HALT,
            inventory: [new _item.IronLance()]}),

            new _uclass.Soldier({pos: new Position(7, 5),
            level: 2, aiType: _unit.AI_TYPE.HALT,
            inventory: [new _item.IronLance()]}),

            new _uclass.Mercenary({pos: new Position(7, 8),
            level: 1,
            inventory: [new _item.IronSword()]}),

            new _uclass.Fighter({pos: new Position(6, 7),
            level: 1,
            inventory: [new _item.IronAxe()]}),

            new _uclass.Archer({pos: new Position(6, 15),
            level: 1, aiType: _unit.AI_TYPE.HALT
            inventory: [new _item.IronBow()]}),

            new _uclass.Archer({pos: new Position(7, 14),
            level: 1,
            inventory: [new _item.IronBow()]}),

            new _uclass.Fighter({pos: new Position(1, 8),
            level: 1,
            inventory: [new _item.IronAxe()]}),

            new _uclass.Fighter({pos: new Position(3, 10),
            level: 1,
            inventory: [new _item.IronAxe()]}),

            new _uclass.Mercenary({pos: new Position(3, 12),
            level: 1,
            inventory: [new _item.IronSword()]}),

            new _uclass.Mercenary({pos: new Position(6, 12),
            level: 1,
            inventory: [new _item.IronSword()]}),

            new _uclass.Fighter({pos: new Position(3, 15),
            aiType: _unit.AI_TYPE.HALT,
            boss: true,
            level: 5,
            inventory: [new _item.IronAxe()]})
        ]

        @enemyTeam = new _team.EnemyTeam(enemyUnits, {defaultName: 'Bandit'})
        @enemyTeam.insigniaImagePath = 'images/bandit_insignia.png'

        terrainMapping = {
            0: _terrain.Plain
            1: _terrain.Rocks
            2: _terrain.Forest
        }

        tiles = [
            [0, 0, 0, 2, 2, 1, 1, 2, 2, 1, 1, 1, 0, 2, 1, 1],
            [0, 0, 0, 0, 2, 1, 1, 2, 0, 0, 0, 0, 0, 0, 0, 1],
            [0, 0, 0, 0, 2, 1, 1, 0, 0, 0, 0, 2, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, 0, 0, 2],
            [0, 0, 0, 2, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0],
            [0, 0, 2, 0, 0, 1, 0, 0, 0, 2, 1, 1, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 2, 0, 0, 2, 0, 0, 0, 2, 0, 0, 2],
            [0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 2, 2, 1],
            [1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 2, 0, 0, 2, 2, 2],
            [1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1, 2, 1, 1, 1],
        ]

        playerPositions = [[2,1], [1,0], [0,1], [1, 2]]
        @origin0 = new Position(0, 4*@ui.tw)
        @victoryCondition = _map.VICTORY_CONDITION.ROUT
        
        map = new _map.Map(tiles, terrainMapping, playerPositions)
        super(@ui, map)

    doScrollSequence: (callback) ->
        f = =>
            @ui.scrollTo(new Position(0, 0), callback, .07)

        setTimeout(f, 1000/@ui.speedMultiplier)

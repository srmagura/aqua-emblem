window._chapters = {}

class _chapters.Chapter1 extends _map.Chapter

    constructor: (@ui) ->     
        enemyUnits = [
            new _enemy.Fighter({pos: new Position(4, 2),
            level: 1}),

            new _enemy.Fighter({pos: new Position(5, 4),
            level: 1}),

            new _enemy.Archer({pos: new Position(8, 3),
            level: 1}),

            new _enemy.Soldier({pos: new Position(6, 5),
            level: 2, aiType: _unit.aiType.halt,
            items: [new _item.SteelLance().letDrop()]}),

            new _enemy.Soldier({pos: new Position(7, 5),
            level: 2, aiType: _unit.aiType.halt}),

            new _enemy.Mercenary({pos: new Position(7, 8),
            level: 1}),

            new _enemy.Fighter({pos: new Position(6, 7),
            level: 1}),

            new _enemy.Archer({pos: new Position(6, 15),
            level: 1, aiType: _unit.aiType.halt}),

            new _enemy.Archer({pos: new Position(7, 14),
            level: 1,
            items: [new _item.IronBow(), new _item.KillerBow().letDrop()]}),

            new _enemy.Fighter({pos: new Position(1, 8),
            level: 1}),

            new _enemy.Fighter({pos: new Position(3, 10),
            level: 1}),

            new _enemy.Mercenary({pos: new Position(3, 12),
            level: 1}),

            new _enemy.Mercenary({pos: new Position(6, 12),
            level: 1}),

            new _enemy.Fighter({pos: new Position(3, 15),
            aiType: _unit.aiType.halt,
            boss: true,
            level: 5,
            items: [new _item.HandAxe().letDrop()]})
        ]

        @enemyTeam = new _team.EnemyTeam(enemyUnits, {defaultName: 'Bandit'})

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

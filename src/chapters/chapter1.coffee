class window.Chapter1 extends Chapter

    constructor: (ui) ->
        playerUnits = [
            new uclass.special.Ace(),
            new uclass.special.Arrow(),
            new uclass.special.Luciana(),
            new uclass.special.Kenji(),
        ]
        playerTeam = new PlayerTeam(playerUnits)
     
        enemyUnits = [
            new uclass.Fighter({pos: new Position(4, 2),
            level: 1,
            inventory: [new item.IronAxe()]}),

            new uclass.Fighter({pos: new Position(5, 4),
            level: 1,
            inventory: [new item.IronAxe()]}),

            new uclass.Archer({pos: new Position(8, 3),
            level: 1,
            inventory: [new item.IronBow()]}),

            new uclass.Soldier({pos: new Position(6, 5),
            level: 2, aiType: AI_TYPE.HALT,
            inventory: [new item.IronLance()]}),

            new uclass.Soldier({pos: new Position(7, 5),
            level: 2, aiType: AI_TYPE.HALT,
            inventory: [new item.IronLance()]}),

            new uclass.Mercenary({pos: new Position(7, 8),
            level: 1,
            inventory: [new item.IronSword()]}),

            new uclass.Fighter({pos: new Position(6, 7),
            level: 1,
            inventory: [new item.IronAxe()]}),

            new uclass.Archer({pos: new Position(6, 15),
            level: 1, aiType: AI_TYPE.HALT
            inventory: [new item.IronBow()]}),

            new uclass.Archer({pos: new Position(7, 14),
            level: 1,
            inventory: [new item.IronBow()]}),

            new uclass.Fighter({pos: new Position(1, 7),
            level: 1,
            inventory: [new item.IronAxe()]}),

            new uclass.Fighter({pos: new Position(3, 9),
            level: 1,
            inventory: [new item.IronAxe()]}),

            new uclass.Mercenary({pos: new Position(3, 12),
            level: 1,
            inventory: [new item.IronSword()]}),

            new uclass.Mercenary({pos: new Position(6, 12),
            level: 1,
            inventory: [new item.IronSword()]}),

            new uclass.Fighter({pos: new Position(3, 15),
            aiType: AI_TYPE.HALT,
            boss: true,
            level: 3,
            inventory: [new item.IronAxe()]})
        ]
        enemyTeam = new EnemyTeam(enemyUnits, {defaultName: 'Bandit'})
        enemyTeam.insigniaImagePath = 'images/bandit_insignia.png'

        terrainMapping = {
            0: terrain.Plain
            1: terrain.Rocks
            2: terrain.Forest
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

        map = new Map(tiles, terrainMapping, playerPositions)
        super(ui, map, playerTeam, enemyTeam,
        VICTORY_CONDITION.ROUT)

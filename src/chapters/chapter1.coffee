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
            new uclass.Mercenary({pos: new Position(4, 2),
            level: 1,
            inventory: [new item.IronSword()]}),

            new uclass.Mercenary({pos: new Position(6, 4),
            level: 1,
            inventory: [new item.IronSword()]}),

            new uclass.Archer({pos: new Position(8, 3),
            level: 1,
            inventory: [new item.IronBow()]}),

            new uclass.Mercenary({pos: new Position(3, 15),
            #aiType: AI_TYPE.HALT,
            boss: true,
            level: 1,
            move: 25,
            inventory: [new item.IronSword()]})
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
            [0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 2],
            [0, 0, 0, 2, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 2, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 2, 0, 0, 2, 0, 0, 0, 0, 0, 0, 2],
            [0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
            [1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 2, 0, 0, 0, 0, 2],
            [1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1, 2, 1, 1, 1],
        ]

        playerPositions = [[0,1], [1,0], [2,1], [1, 2]]

        map = new Map(tiles, terrainMapping, playerPositions)
        super(ui, map, playerTeam, enemyTeam,
        VICTORY_CONDITION.ROUT)

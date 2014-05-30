class window.ChapterTestHuge extends Chapter

    constructor: (ui) ->
        playerUnits = [
            new uclass.special.Ace(),
            new uclass.special.Arrow(),
            new uclass.special.Luciana(),
            new uclass.special.Kenji(),
        ]
        playerTeam = new PlayerTeam(playerUnits)
     
        enemyUnits = [
            new uclass.Mercenary({pos: new Position(1, 0),
            level: -10,
            inventory: [new item.IronSword()]}),

            #new uclass.Mercenary({pos: new Position(6, 4),
            #level: 1,
            #inventory: [new item.IronSword()]}),

            #new uclass.Archer({pos: new Position(8, 3),
            #level: 1,
            #inventory: [new item.IronBow()]}),

            #new uclass.Mercenary({name: 'Bandit lord',
            #pos: new Position(2, 11),
            #aiType: AI_TYPE.HALT,
            #level: 3,
            #inventory: [new item.IronSword()]})
        ]
        enemyTeam = new EnemyTeam(enemyUnits, {defaultName: 'Bandit'})
        enemyTeam.insigniaImagePath = 'images/bandit_insignia.png'

        terrainMapping = {
            0: terrain.Plain
        }

        tiles = [
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        ]

        playerPositions = [[0,0], [14,0], [0,15], [14, 19]]

        map = new Map(tiles, terrainMapping, playerPositions)
        super(ui, map, playerTeam, enemyTeam,
        VICTORY_CONDITION.ROUT)

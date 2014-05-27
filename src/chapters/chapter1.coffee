class window.Chapter1 extends Chapter

    constructor: (ui) ->
        playerUnits = [
            new uclass.special.Ace(),
            new uclass.special.Arrow()
        ]
        playerTeam = new Team(playerUnits)
     
        enemyUnits = [
            new uclass.Mercenary({pos: new Position(4, 2),
            level: 1,
            inventory: [new item.IronSword()]}),

            new uclass.Mercenary({pos: new Position(6, 4),
            level: 1,
            inventory: [new item.IronSword()]}),

            new uclass.Mercenary({pos: new Position(3, 5),
            level: 1,
            inventory: [new item.IronSword()]}),

            new uclass.Mercenary({name: 'Bandit lord',
            pos: new Position(2, 11),
            aiType: AI_TYPE.HALT,
            level: 3,
            inventory: [new item.IronSword()]})
        ]
        enemyTeam = new Team(enemyUnits, {defaultName: 'Bandit',
        isAi: true})
        enemyTeam.insigniaImagePath = 'images/bandit_insignia.png'

        tiles = [
            [0, 0, 0, 1, 1, 1, 1, 2, 2, 1, 1, 1],
            [0, 0, 0, 0, 1, 1, 1, 2, 0, 0, 0, 0],
            [0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 2],
            [0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0],
            [0, 0, 0, 2, 0, 1, 1, 0, 0, 0, 0, 0],
            [0, 0, 2, 0, 0, 1, 0, 0, 0, 2, 0, 0],
            [0, 0, 0, 0, 0, 2, 0, 0, 2, 0, 0, 1],
            [0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 1],
            [1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 2, 1],
            [1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1],
        ]

        playerPositions = [[0,1], [1,0]]

        map = new Map(tiles, playerPositions)
        super(ui, map, playerTeam, enemyTeam,
        VICTORY_CONDITION.ROUT)

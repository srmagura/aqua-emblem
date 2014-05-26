class window.TestChapter1 extends Chapter

    constructor: (ui) ->
        playerUnits = [
            new uclass.special.Ace(),
            new uclass.special.Arrow()
        ]
        playerTeam = new Team(playerUnits)
     
        enemyUnits = [
            new uclass.Mercenary({pos: new Position(4, 2),
            level: 1,
            inventory: [new Item('iron-sword')]}),

            new uclass.Mercenary({pos: new Position(6, 4),
            level: 1,
            inventory: [new Item('iron-sword')]}),

            new uclass.Mercenary({pos: new Position(3, 5),
            level: 1,
            inventory: [new Item('iron-sword')]}),

            new uclass.Mercenary({name: 'Bandit lord',
            pos: new Position(0, 5),
            aiType: AI_TYPE.HALT,
            level: 3,
            inventory: [new Item('iron-sword')]})
        ]
        enemyTeam = new Team(enemyUnits, {defaultName: 'Bandit',
        isAi: true})
        enemyTeam.insigniaImagePath = 'images/bandit_insignia.png'

        tiles = [
            [1, 1, 0, 1, 0, 0, 0],
            [1, 0, 0, 1, 0, 0, 0],
            [0, 0, 0, 1, 1, 0, 0],
            [0, 0, 0, 1, 1, 0, 0],
            [0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0],
            [1, 1, 0, 0, 0, 0, 0]
        ]

        playerPositions = [[2,1], [3,0]]

        map = new Map(tiles, playerPositions)
        super(ui, map, playerTeam, enemyTeam,
        VICTORY_CONDITION.ROUT)

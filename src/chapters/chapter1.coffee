class window.Chapter1 extends Chapter

    constructor: (ui) ->
        playerUnits = [
            new Unit({name: 'Ace', baseHp: 22, baseMp: 5,
            move: 4, str: 7, def: 5,
            skill: 5, speed: 6, res: 2, luck: 8, aid: 7, con: 5,
            mag: 0, picture: true, lord: true,
            inventory: [new Item('iron-sword')]})
        ]
        playerTeam = new Team(playerUnits)
     
        enemyUnits = [
            new Unit({name: 'Bandit', pos: new Position(4, 2),
            baseHp: 14,
            move: 4, str: 2, def: 1,
            inventory: [new Item('iron-sword')]}),
            new Unit({name: 'Bandit',
            pos: new Position(6, 4),
            baseHp: 14,
            move: 4, str: 2, def: 1,
            inventory: [new Item('iron-sword')]}),
            new Unit({name: 'Bandit',
            pos: new Position(3, 5), baseHp: 14,
            move: 4, str: 2, def: 1,
            inventory: [new Item('iron-sword')]}),
            new Unit({name: 'Bandit lord',
            pos: new Position(0, 5),
            aiType: AI_TYPE.HALT,
            baseHp: 22,
            move: 4, str: 4, def: 1,
            inventory: [new Item('iron-sword')]})
        ]
        enemyTeam = new Team(enemyUnits)
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

        playerPositions = [[2,1]]

        map = new Map(tiles, playerPositions)
        super(ui, map, playerTeam, enemyTeam,
        VICTORY_CONDITION.ROUT)

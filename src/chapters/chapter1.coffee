class window.Chapter1 extends Chapter

    constructor: (ui) ->
        playerUnits = [
            new Unit({name: 'Ace', baseHp: 25, baseMp: 5,
            move: 4, str: 7, def: 5,
            skill: 5, speed: 6, res: 2, luck: 8, aid: 7, con: 5,
            mag: 0, picture: true,
            lord: true})
                #inventory: [new Item('iron-sword')]})
        ]
        playerTeam = new Team(playerUnits)
        enemyTeam = new Team([])

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
        super(ui, map, playerTeam, enemyTeam, VC.ROUT)

###
var playerUnits = [
    new Unit({name: 'Ace', baseHp: 25, baseMp: 5, 
        move: 4, str: 7, def: 5,
        skill: 5, speed: 6, res: 2, luck: 8, aid: 7, con: 5,
        mag: 0, picture: true, 
        lord: true, inventory: [new Item('iron-sword')]})
]
var playerTeam = new Team(playerUnits, TEAM_PLAYER)

var enemyUnits = [
    new Unit({name: 'Bandit', pos: [4, 2],
        baseHp: 14, 
        move: 4, str: 2, def: 1,
        inventory: [new Item('iron-sword')]}),
    new Unit({name: 'Bandit', pos: [6, 4], baseHp: 14, 
        move: 4, str: 2, def: 1,
        inventory: [new Item('iron-sword')]}),
    new Unit({name: 'Bandit', pos: [3, 5], baseHp: 14, 
        move: 4, str: 2, def: 1,
        inventory: [new Item('iron-sword')]}),
    new Unit({name: 'Bandit lord', pos: [0, 5], aiType: AI_HALT,
        baseHp: 22, 
        move: 4, str: 4, def: 1,
        inventory: [new Item('iron-sword')]})
]
var enemyTeam = new Team(enemyUnits, TEAM_ENEMY)
enemyTeam.insigniaImagePath = 'images/bandit_insignia.png'
###

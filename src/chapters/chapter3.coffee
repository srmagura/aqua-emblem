class _chapters.Chapter3 extends _map.Chapter

    constructor: (@ui) ->
        @ui.file.playerTeam.addUnit(new _unit.special.Shiina())

        halt = _unit.aiType.halt
        agg = _unit.aiType.aggressive
       
        enemyUnits = [
            new _uclass.Archer({pos: new Position(10, 9),
            level: 3, items: [new _item.IronBow()]}),
                      
            new _uclass.Fighter({pos: new Position(12, 1),
            boss: true, level: 10,
            items: []}),
        ]
        
        reinforcements1 = [
        #    {
        #        cls: _uclass.Soldier, 
        #        attr: {
        #            pos: new Position(0, 9),
        #            level: 2, items: [new _item.IronLance()],
        #            aiType: agg
        #        },
        #    },
        ]
        
        reinforcements = []
        
        for turn in [4, 6, 8]
            for obj in reinforcements1
                unit = new obj.cls(obj.attr)
                unit.spawnTurn = turn
                reinforcements.push(unit)
                
        @enemyTeam = new _team.EnemyTeam(enemyUnits, {
            defaultName: 'Bandit',
            reinforcements: reinforcements
        })

        terrainMapping = {
            0: _terrain.Plain,
            1: _terrain.Rocks,
            2: _terrain.Forest,
            3: _terrain.River,
            4: _terrain.Bridge,
            5: _terrain.Fort,
        }

        tiles = [
            [1, 2, 2, 1, 1, 1, 2, 2, 2, 1, 1, 1, 0, 1, 1, 0],
            [0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0],
            [0, 1, 1, 2, 1, 1, 0, 0, 0, 0, 1, 1, 0, 1, 2, 0],
            [0, 0, 1, 2, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 2],
            [0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 1, 0, 0, 0, 0],
            [1, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 2, 0],
            [2, 0, 2, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0],
            [2, 0, 0, 1, 2, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 2],
            [1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 2, 0, 0, 2, 0, 1],
            [0, 0, 0, 0, 0, 2, 1, 0, 1, 1, 0, 0, 0, 0, 0, 1],
            [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 1],
            [1, 0, 1, 1, 0, 0, 1, 0, 2, 0, 0, 1, 0, 0, 1, 1],
            [1, 2, 1, 1, 0, 0, 2, 1, 0, 0, 1, 1, 0, 0, 1, 1],
            [1, 1, 1, 2, 2, 0, 2, 1, 0, 1, 1, 1, 0, 0, 0, 1],
        ]

        playerPositions = [[2,7], [1,6], [3,8], [2, 9], [1, 8]]
        @origin0 = new Position(6*@ui.tw, 0)
        @victoryCondition = _map.VICTORY_CONDITION.ROUT
        
        map = new _map.Map(tiles, terrainMapping, playerPositions)
        super(@ui, map)

    doScrollSequence: (callback) ->
        f = =>
            @ui.scrollTo(new Position(0, 0), callback, .07)

        setTimeout(f, 1000/@ui.speedMultiplier)

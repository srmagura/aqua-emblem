class _chapters.Chapter3 extends _map.Chapter

    constructor: (@ui) ->
        @ui.file.playerTeam.addUnit(new _unit.special.Shiina())
       
        enemyUnits = [
            new _uclass.Mercenary({pos: new Position(3, 3),
            level: 3, items: [new _item.IronSword()]}),
            
            new _uclass.Mercenary({pos: new Position(6, 7),
            level: 3, items: [new _item.IronSword()]}),
            
            new _uclass.Mercenary({pos: new Position(4, 15),
            level: 4, items: [new _item.IronSword()]}),
            
            new _uclass.Soldier({pos: new Position(1, 2),
            level: 3, items: [new _item.SteelLance()]}),
            
            new _uclass.Soldier({pos: new Position(4, 12),
            level: 3, items: [new _item.IronLance()]}),
            
            new _uclass.Soldier({pos: new Position(7, 4),
            level: 3, items: [new _item.IronLance()]}),
            
            new _uclass.Soldier({pos: new Position(6, 15),
            level: 4, items: [new _item.IronLance()]}),
            
            new _uclass.Fighter({pos: new Position(13, 12),
            level: 4, items: [new _item.IronAxe()]}),
            
            new _uclass.Fighter({pos: new Position(0, 15),
            level: 4, items: [new _item.IronAxe()]}),
            
            new _uclass.Fighter({pos: new Position(13, 4),
            level: 3, items: [new _item.IronAxe()]}),
            
            new _uclass.Fighter({pos: new Position(13, 5),
            level: 3, items: [new _item.IronAxe()]}),
            
            new _uclass.Mercenary({pos: new Position(0, 2),
            level: 4, items: [new _item.SteelSword()]
            aiOptions: {startTurn: 4}}),
            
            new _uclass.Mercenary({pos: new Position(3, 0),
            level: 4, items: [new _item.IronSword()]
            aiOptions: {startTurn: 1}}),
            
            new _uclass.Archer({pos: new Position(13, 5),
            level: 4, items: [new _item.IronBow()]}),
            
            new _uclass.Archer({pos: new Position(8, 14),
            level: 3, items: [new _item.IronBow()]
            aiOptions: {startTurn: 2}}),
            
            new _uclass.Archer({pos: new Position(7, 15),
            level: 4, items: [new _item.SteelBow()],
            aiOptions: {startTurn: 2}}),
            
            new _uclass.Mercenary({pos: new Position(9, 12),
            level: 4, items: [new _item.IronSword()],
            aiOptions: {startTurn: 2}}),
            
            new _uclass.Fighter({pos: new Position(13, 13),
            level: 3, items: [new _item.HandAxe()],
            aiOptions: {startTurn: 2}}),
            
            new _uclass.Fighter({pos: new Position(9, 0),
            level: 3, items: [new _item.IronAxe()],
            aiOptions: {startTurn: 2}}),
            
            new _uclass.Fighter({pos: new Position(7, 0),
            level: 4, items: [new _item.SteelAxe()],
            aiOptions: {startTurn: 2}}),
            
            new _uclass.Fighter({pos: new Position(6, 11),
            level: 4, items: [new _item.IronAxe()]}),
        
            new _uclass.Archer({pos: new Position(10, 9),
            level: 3, items: [new _item.IronBow()]
            aiOptions: {startTurn: 2}}),
                      
            new _uclass.Soldier({pos: new Position(12, 1),
            boss: true, level: 10,
            items: [new _item.SteelLance()],
            aiOptions: {startTurn: 5}})
            
        ]
        
        reinforcements1 = [
            {
                cls: _uclass.Fighter, 
                attr: {
                    pos: new Position(13, 13),
                    level: 3, items: [new _item.IronAxe()],
                },
           },
           { 
                cls: _uclass.Archer, 
                attr: {
                    pos: new Position(13, 5),
                    level: 3, items: [new _item.IronBow()],
                },
            },
        ]
        
        reinforcements = []
        
        for turn in [1,3,5,7]
            for obj in reinforcements1
                unit = new obj.cls(obj.attr)
                unit.spawnTurn = turn
                reinforcements.push(unit)
                
        @enemyTeam = new _team.EnemyTeam(enemyUnits, {
            defaultName: 'Bandit',
            defaultAiType: _unit.aiType.aggressive,
            reinforcements: reinforcements
        })

        terrainMapping = {
            0: _terrain.Plain,
            1: _terrain.Rocks,
            2: _terrain.Forest,
            5: _terrain.Fort,
        }

        tiles = [
            [1, 2, 2, 1, 1, 1, 2, 2, 2, 1, 1, 1, 2, 1, 1, 2],
            [0, 0, 2, 0, 1, 1, 2, 0, 2, 2, 2, 2, 0, 0, 0, 2],
            [0, 1, 1, 2, 1, 1, 0, 0, 0, 0, 1, 1, 0, 1, 2, 2],
            [2, 2, 1, 2, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 2],
            [0, 0, 0, 0, 0, 2, 0, 2, 0, 2, 0, 1, 2, 0, 0, 0],
            [1, 0, 1, 1, 0, 0, 2, 1, 1, 0, 0, 0, 0, 1, 2, 0],
            [2, 2, 2, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0],
            [2, 0, 0, 1, 2, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 2],
            [1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 2, 0, 0, 2, 0, 1],
            [0, 2, 0, 0, 0, 2, 1, 0, 1, 1, 0, 0, 0, 0, 0, 1],
            [2, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 2, 1, 1],
            [1, 0, 1, 1, 2, 0, 1, 0, 2, 0, 0, 1, 0, 0, 1, 1],
            [1, 2, 1, 1, 2, 0, 2, 1, 0, 0, 1, 1, 0, 0, 1, 1],
            [1, 1, 1, 2, 2, 5, 2, 1, 0, 1, 1, 1, 2, 5, 2, 1],
        ]

        playerPositions = [[2,7], [1,6], [3,8], [2, 9], [1, 8]]
        @origin0 = new Position(4*@ui.tw, 0)
        @victoryCondition = _map.VICTORY_CONDITION.ROUT
        
        map = new _map.Map(tiles, terrainMapping, playerPositions)
        super(@ui, map)

    doScrollSequence: (callback) ->
        # 4, 0 -> 4, 4 -> 0, 2
        f = =>
            @ui.scrollTo(new Position(0, 0), callback, .07)

        setTimeout(f, 1000/@ui.speedMultiplier)

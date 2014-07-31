class _chapters.Chapter2 extends _map.Chapter

    constructor: (@ui) ->
        halt = _unit.aiType.halt
        agg = _unit.aiType.aggressive
       
        enemyUnits = [
            new _uclass.Archer({pos: new Position(0, 8),
            level: 3, items: [new _item.IronBow()]}),
            
            new _uclass.Archer({pos: new Position(0, 9),
            level: 2, items: [new _item.IronBow()],
            aiType: agg}),
            
            new _uclass.Soldier({pos: new Position(7, 2),
            level: 2, items: [new _item.IronLance()],
            aiType: agg}),
            
            new _uclass.Soldier({pos: new Position(7, 8),
            level: 2, items: [new _item.IronLance()],
            aiType: agg}),
            
            new _uclass.Soldier({pos: new Position(4, 7),
            level: 2, items: [new _item.IronLance()],
            aiType: agg}),
            
            new _uclass.Soldier({pos: new Position(4, 11),
            level: 3, items: [new _item.IronLance()]}),
        
            new _uclass.Mercenary({pos: new Position(6, 10),
            level: 2, items: [new _item.IronSword()],
            aiType: agg}),
            
            new _uclass.Mercenary({pos: new Position(2, 10),
            level: 3, items: [new _item.SteelSword().letDrop()]}),
            
            new _uclass.Soldier({pos: new Position(9, 5),
            level: 3, items: [new _item.IronLance()]}),
            
            new _uclass.Archer({pos: new Position(14, 0),
            level: 2, items: [new _item.IronBow()],
            aiType: agg}),
            
            new _uclass.Archer({pos: new Position(15, 1),
            level: 2, items: [new _item.SteelBow().letDrop()],
            aiType: agg}),
            
            new _uclass.Soldier({pos: new Position(14, 11),
            level: 3, items: [new _item.IronLance()]}),
            
            new _uclass.Mercenary({pos: new Position(14, 9),
            level: 2, items: [new _item.IronSword()],
            aiType: halt}),
            
            new _uclass.Soldier({pos: new Position(12, 3),
            level: 2, items: [new _item.IronLance()],
            aiType: agg}),
            
            new _uclass.Soldier({pos: new Position(13, 5),
            level: 2, items: [new _item.IronLance()],
            aiType: agg}),
            
            new _uclass.Mercenary({pos: new Position(10, 7),
            level: 3, items: [new _item.IronSword()]}),
            
            new _uclass.Mercenary({pos: new Position(15, 8),
            level: 3, items: [new _item.IronSword()]}),
            
            new _uclass.Mercenary({pos: new Position(15, 4),
            level: 2, items: [new _item.IronSword()]}),
            
            new _uclass.Fighter({pos: new Position(15, 10),
            name: 'Morgan', boss: true, picture: true,
            level: 10, aiType: halt,
            items: [new _item.HandAxe(), new _item.SteelAxe().letDrop()]}),
        ]
        
        reinforcements1 = [
            {
                cls: _uclass.Soldier, 
                attr: {
                    pos: new Position(0, 9),
                    level: 2, items: [new _item.IronLance()],
                    aiType: agg
                },
            },
            {
                cls: _uclass.Mercenary,
                attr: {
                    pos: new Position(15, 1),
                    level: 2, items: [new _item.IronSword()],
                    aiType: agg
                },
            },
            {
                cls: _uclass.Archer,
                attr: {
                    pos: new Position(14, 0),
                    level: 2, items: [new _item.IronBow()],
                    aiType: agg
                },
            }
        ]
        
        reinforcements = []
        
        for turn in [4, 6, 8]
            for obj in reinforcements1
                unit = new obj.cls(obj.attr)
                unit.spawnTurn = turn
                reinforcements.push(unit)
                
        @enemyTeam = new _team.EnemyTeam(enemyUnits, {
            defaultName: 'Sellsword',
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
            [2, 2, 0, 2, 1, 1, 0, 2, 5, 5, 2, 0],
            [0, 0, 0, 2, 1, 1, 0, 0, 2, 0, 0, 0],
            [2, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, 2],
            [0, 0, 0, 1, 1, 2, 0, 0, 0, 0, 0, 2],
            [1, 2, 0, 0, 0, 2, 0, 2, 2, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2],
            [0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2],
            [0, 0, 0, 2, 2, 0, 0, 0, 0, 2, 2, 2],
            [3, 3, 3, 3, 3, 4, 3, 3, 3, 3, 3, 3],  
            [0, 2, 2, 0, 0, 0, 0, 2, 0, 0, 2, 2],
            [0, 0, 0, 0, 2, 0, 0, 0, 0, 2, 0, 0],
            [0, 2, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0],            
            [2, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0],
            [5, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 2], 
            [0, 5, 0, 2, 2, 2, 2, 0, 0, 0, 2, 0], 
        ]

        playerPositions = [[0,1], [1,0], [2,1], [1, 2]]
        @origin0 = new Position(6*@ui.tw, 0)
        @victoryCondition = _map.VICTORY_CONDITION.ROUT
        
        map = new _map.Map(tiles, terrainMapping, playerPositions)
        super(@ui, map)

    doScrollSequence: (callback) ->
        f = =>
            @ui.scrollTo(new Position(0, 0), callback, .07)

        setTimeout(f, 1000/@ui.speedMultiplier)
class _chapters.Chapter3 extends _map.Chapter

    constructor: (@ui) ->
        @ui.file.playerTeam.addUnit(new _unit.special.Shiina())
       
        enemyUnits = [
            new _enemy.Mercenary({pos: new Position(3, 3),
            }),
            
            new _enemy.Mercenary({pos: new Position(6, 7),
            }),
            
            new _enemy.Mercenary({pos: new Position(4, 15),
            }),
            
            new _enemy.Soldier({pos: new Position(1, 2),
            items: [new _item.SteelLance()]}),
            
            new _enemy.Soldier({pos: new Position(4, 12),
            }),
            
            new _enemy.Soldier({pos: new Position(7, 4),
            }),
            
            new _enemy.Soldier({pos: new Position(6, 15),
            }),
            
            new _enemy.Fighter({pos: new Position(13, 12),
            }),
            
            new _enemy.Fighter({pos: new Position(0, 15),
            }),
            
            new _enemy.Fighter({pos: new Position(13, 4),
            }),
            
            new _enemy.Fighter({pos: new Position(13, 5),
            dld: -2}),
            
            new _enemy.Mercenary({pos: new Position(0, 2),
            items: [new _item.SteelSword()]
            aiOptions: {startTurn: 4}}),
            
            new _enemy.Mercenary({pos: new Position(3, 0),
            aiOptions: {startTurn: 1}}),
            
            new _enemy.Archer({pos: new Position(8, 14),
            aiOptions: {startTurn: 2}}),
            
            new _enemy.Archer({pos: new Position(7, 15),
            dld: 2, items: [new _item.SteelBow()],
            aiOptions: {startTurn: 2}}),
            
            new _enemy.Mercenary({pos: new Position(9, 12),
            aiOptions: {startTurn: 2}}),
            
            new _enemy.Fighter({pos: new Position(13, 13),
            items: [new _item.HandAxe()],
            aiOptions: {startTurn: 2}}),
            
            new _enemy.Fighter({pos: new Position(9, 0),
            aiOptions: {startTurn: 2}}),
            
            new _enemy.Fighter({pos: new Position(7, 0),
            items: [new _item.SteelAxe()],
            dld: 1, aiOptions: {startTurn: 2}}),
            
            new _enemy.Fighter({pos: new Position(6, 11),
            dld: 2, }),
        
            new _enemy.Archer({pos: new Position(10, 9),
            dld: 2, aiOptions: {startTurn: 2}}),
                      
            new _enemy.Soldier({pos: new Position(12, 1),
            boss: true, dld: 3,
            items: [new _item.BraveLance().letDrop()],
            aiOptions: {startTurn: 5}})
            
        ]
        
        reinforcements1 = [
            {
                cls: _enemy.Fighter, 
                attr: {
                    pos: new Position(13, 13),
                },
           },
           { 
                cls: _enemy.Archer, 
                attr: {
                    pos: new Position(13, 5),
                    dld: -1
                },
            },
        ]
        
        reinforcements = []
        
        for turn in [3, 5, 7]
            for obj in reinforcements1
                unit = new obj.cls(obj.attr)
                unit.spawnTurn = turn
                reinforcements.push(unit)
                
        @enemyTeam = new _team.EnemyTeam(enemyUnits, {
            defaultName: 'Bandit',
            defaultAiType: _unit.aiType.aggressive,
            defaultLevel: 5,
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
            [0, 0, 0, 0, 0, 0, 2, 2, 0, 2, 0, 1, 2, 0, 0, 0],
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

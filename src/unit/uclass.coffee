window._uclass = {}

class _uclass.Mercenary extends _unit.Unit
    constructor: (attr) ->
        @uclassName = 'Mercenary'
        @wield = [_item.Sword]

        startStats = {maxHp: 18, move: 5, str: 2, def: 1,
        skill: 3, speed: 3, res: 1, luck: 0, mag: 0}
        @fillInStartStats(startStats)

        if not @growthRates?
            @growthRates = {maxHp: .8, str: .5, skill: .35,
            speed: .35, luck: .1, def: .25, res: .15}

        super(attr)

class _uclass.Archer extends _unit.Unit
    constructor: (attr) ->
        @uclassName = 'Archer'
        @wield = [_item.Bow]

        startStats = {maxHp: 16, move: 5, str: 2, def: 2,
        skill: 3, speed: 2, res: 1, luck: 0, mag: 0}
        @fillInStartStats(startStats)

        if not @growthRates?
            @growthRates = {maxHp: .65, str: .4, skill: .45,
            speed: .40, luck: .1, def: .25, res: .15}

        super(attr)

class _uclass.Soldier extends _unit.Unit
    constructor: (attr) ->
        @uclassName = 'Soldier'
        @wield = [_item.Lance]

        startStats = {maxHp: 20, move: 5, str: 2, def: 3,
        skill: 1, speed: 1, res: 1, luck: 0, mag: 0}
        @fillInStartStats(startStats)

        if not @growthRates?
            @growthRates = {maxHp: .8, str: .5, skill: .35,
            speed: .35, luck: .1, def: .25, res: .15}

        super(attr)

class _uclass.Fighter extends _unit.Unit
    constructor: (attr) ->
        @uclassName = 'Fighter'
        @wield = [_item.Axe]

        startStats = {maxHp: 23, move: 5, str: 3, def: 1,
        skill: 1, speed: 2, res: 1, luck: 0, mag: 0}
        @fillInStartStats(startStats)

        if not @growthRates?
            @growthRates = {maxHp: .8, str: .5, skill: .35,
            speed: .35, luck: .1, def: .25, res: .15}

        super(attr)

window._uclass = {special: {}}

class _uclass.Mercenary extends Unit
    constructor: (attr) ->
        @uclassName = 'Mercenary'
        @wield = [_item.Sword]

        baseStats = {baseHp: 18, move: 5, str: 3, def: 2,
        skill: 4, speed: 4, res: 1, luck: 2, mag: 0}
        @fillInBaseStats(baseStats)

        if not @growthRates?
            @growthRates = {baseHp: .8, str: .5, skill: .35,
            speed: .35, luck: .1, def: .25, res: .15}

        super(attr)

class _uclass.Archer extends Unit
    constructor: (attr) ->
        @uclassName = 'Archer'
        @wield = [_item.Bow]

        baseStats = {baseHp: 16, move: 5, str: 2, def: 2,
        skill: 3, speed: 3, res: 1, luck: 2, mag: 0}
        @fillInBaseStats(baseStats)

        if not @growthRates?
            @growthRates = {baseHp: .65, str: .4, skill: .45,
            speed: .40, luck: .1, def: .25, res: .15}

        super(attr)

class _uclass.Soldier extends Unit
    constructor: (attr) ->
        @uclassName = 'Soldier'
        @wield = [_item.Lance]

        baseStats = {baseHp: 20, move: 5, str: 2, def: 4,
        skill: 2, speed: 2, res: 1, luck: 2, mag: 0}
        @fillInBaseStats(baseStats)

        if not @growthRates?
            @growthRates = {baseHp: .8, str: .5, skill: .35,
            speed: .35, luck: .1, def: .25, res: .15}

        super(attr)

class _uclass.Fighter extends Unit
    constructor: (attr) ->
        @uclassName = 'Fighter'
        @wield = [_item.Axe]

        baseStats = {baseHp: 23, move: 5, str: 3, def: 1,
        skill: 1, speed: 2, res: 1, luck: 2, mag: 0}
        @fillInBaseStats(baseStats)

        if not @growthRates?
            @growthRates = {baseHp: .8, str: .5, skill: .35,
            speed: .35, luck: .1, def: .25, res: .15}

        super(attr)

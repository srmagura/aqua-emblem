window.uclass = {special: {}}

class window.uclass.Mercenary extends Unit
    constructor: (attr) ->
        @uclassName = 'Mercenary'
        @wield = [item.Sword]

        baseStats = {baseHp: 18, move: 5, str: 3, def: 2,
        skill: 4, speed: 4, res: 1, luck: 2, mag: 0}
        @fillInBaseStats(baseStats)

        if not @growthRates?
            @growthRates = {baseHp: .8, str: .5, skill: .35,
            speed: .35, luck: .1, def: .25, res: .15}

        super(attr)

class window.uclass.Archer extends Unit
    constructor: (attr) ->
        @uclassName = 'Archer'
        @wield = [item.Bow]

        baseStats = {baseHp: 16, move: 5, str: 2, def: 2,
        skill: 3, speed: 3, res: 1, luck: 2, mag: 0}
        @fillInBaseStats(baseStats)

        if not @growthRates?
            @growthRates = {baseHp: .65, str: .4, skill: .45,
            speed: .40, luck: .1, def: .25, res: .15}

        super(attr)

class window.uclass.Soldier extends Unit
    constructor: (attr) ->
        @uclassName = 'Soldier'
        @wield = [item.Lance]

        baseStats = {baseHp: 20, move: 5, str: 2, def: 4,
        skill: 2, speed: 2, res: 1, luck: 2, mag: 0}
        @fillInBaseStats(baseStats)

        if not @growthRates?
            @growthRates = {baseHp: .8, str: .5, skill: .35,
            speed: .35, luck: .1, def: .25, res: .15}

        super(attr)

class window.uclass.Fighter extends Unit
    constructor: (attr) ->
        @uclassName = 'Fighter'
        @wield = [item.Axe]

        baseStats = {baseHp: 23, move: 5, str: 3, def: 1,
        skill: 1, speed: 2, res: 1, luck: 2, mag: 0}
        @fillInBaseStats(baseStats)

        if not @growthRates?
            @growthRates = {baseHp: .8, str: .5, skill: .35,
            speed: .35, luck: .1, def: .25, res: .15}

        super(attr)

class window.uclass.special.Ace extends uclass.Mercenary
    constructor: ->
        @name = 'Ace'
        @level = 2
        @picture = true
        @inventory = [new item.IronSword()]

        @baseStats = {baseHp: 30, baseMp: 10, str: 6, def: 4,
        skill: 3.8, speed: 5, res: 2, luck: 8, mag: 0}

        @growthRates = {baseHp: .7, baseMp: 1, str: .5, skill: .35,
        speed: .35, luck: .5, def: .4, res: .15}

        super()

class window.uclass.special.Arrow extends uclass.Archer
    constructor: ->
        @name = 'Arrow'
        @level = 1
        @picture = true
        @inventory = [new item.IronBow()]
        @inventory.push(new item.IronBow())

        @baseStats = {baseHp: 24, baseMp: 10, str: 4, def: 4,
        skill: 4.0, speed: 4.1, res: 2, luck: 2, mag: 0}

        @growthRates = {baseHp: .65, baseMp: 1, str: .4, skill: .45,
        speed: .45, luck: .6, def: .25, res: .15}

        super()

class window.uclass.special.Luciana extends uclass.Soldier
    constructor: ->
        @name = 'Luciana'
        @level = 3
        @picture = true
        @inventory = [new item.IronLance()]
        @inventory.push(new item.IronBow())

        @baseStats = {baseHp: 28, baseMp: 10, str: 3.5, def: 6,
        skill: 3.8, speed: 3.2, res: 2, luck: 4, mag: 0}

        @growthRates = {baseHp: .8, baseMp: 1, str: .4, skill: .35,
        speed: .35, luck: .3, def: .5, res: .15}

        super()

class window.uclass.special.Kenji extends uclass.Fighter
    constructor: ->
        @name = 'Kenji'
        @level = 2
        @picture = true
        @inventory = [new item.IronAxe()]

        @baseStats = {baseHp: 36, baseMp: 10, str: 7, def: 3.5,
        skill: 4, speed: 5, res: 2, luck: 4, mag: 0}

        @growthRates = {baseHp: .8, baseMp: 1, str: .5, skill: .35,
        speed: .35, luck: .45, def: .35, res: .15}

        super()

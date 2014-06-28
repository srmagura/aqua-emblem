window.uclass = {special: {}}

class window.uclass.Mercenary extends Unit
    constructor: (attr) ->
        @uclassName = 'Mercenary'
        @wield = [item.Sword]

        baseStats = {baseHp: 18, move: 5, str: 3, def: 1,
        skill: 4, speed: 4, res: 1, luck: 2, mag: 0}
        @fillInBaseStats(baseStats)

        @growthRates = {baseHp: .8, str: .5, skill: .35,
        speed: .35, luck: .1, def: .25, res: .15}

        super(attr)

class window.uclass.Archer extends Unit
    constructor: (attr) ->
        @uclassName = 'Archer'
        @wield = [item.Bow]

        baseStats = {baseHp: 16, move: 5, str: 2, def: 2,
        skill: 4, speed: 3, res: 1, luck: 2, mag: 0}
        @fillInBaseStats(baseStats)

        @growthRates = {baseHp: .65, str: .4, skill: .45,
        speed: .40, luck: .1, def: .25, res: .15}

        super(attr)

class window.uclass.Soldier extends Unit
    constructor: (attr) ->
        @uclassName = 'Soldier'
        @wield = [item.Lance]

        baseStats = {baseHp: 20, move: 5, str: 4, def: 4,
        skill: 2, speed: 2, res: 1, luck: 2, mag: 0}
        @fillInBaseStats(baseStats)

        @growthRates = {baseHp: .8, str: .5, skill: .35,
        speed: .35, luck: .1, def: .25, res: .15}

        super(attr)

class window.uclass.Fighter extends Unit
    constructor: (attr) ->
        @uclassName = 'Fighter'
        @wield = [item.Axe]

        baseStats = {baseHp: 23, move: 5, str: 5, def: 1,
        skill: 1, speed: 2, res: 1, luck: 2, mag: 0}
        @fillInBaseStats(baseStats)

        @growthRates = {baseHp: .8, str: .5, skill: .35,
        speed: .35, luck: .1, def: .25, res: .15}

        super(attr)

class window.uclass.special.Ace extends uclass.Mercenary
    constructor: ->
        @name = 'Ace'
        @level = 1
        @picture = true
        @inventory = [new item.IronSword()]

        @baseStats = {baseHp: 30, baseMp: 10, str: 7, def: 3,
        skill: 4, speed: 6, res: 2, luck: 8, mag: 0}

        super()

class window.uclass.special.Arrow extends uclass.Archer
    constructor: ->
        @name = 'Arrow'
        @level = 1
        @picture = true
        @inventory = [new item.IronBow()]
        @inventory.push(new item.IronBow())

        @baseStats = {baseHp: 28, baseMp: 10, str: 5, def: 4,
        skill: 5, speed: 6, res: 2, luck: 5, mag: 0}

        super()

class window.uclass.special.Luciana extends uclass.Soldier
    constructor: ->
        @name = 'Luciana'
        @level = 1
        @picture = true
        @inventory = [new item.IronLance()]
        @inventory.push(new item.IronBow())

        @baseStats = {baseHp: 23, baseMp: 10, str: 6, def: 6,
        skill: 4, speed: 4, res: 2, luck: 8, mag: 0}

        super()

class window.uclass.special.Kenji extends uclass.Fighter
    constructor: ->
        @name = 'Kenji'
        @level = 1
        @picture = true
        @inventory = [new item.IronAxe()]

        @baseStats = {baseHp: 36, baseMp: 10, str: 7, def: 3,
        skill: 4, speed: 5, res: 2, luck: 8, mag: 0}

        super()

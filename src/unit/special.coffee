class _uclass.special.Ace extends _uclass.Mercenary
    constructor: ->
        @name = 'Ace'
        @level = 2
        @picture = true
        @inventory = [new _item.IronSword()]

        @skills = [new _skill.Flare()]

        @startStats = {maxHp: 30, maxMp: 10, str: 6, def: 4,
        skill: 3.8, speed: 5, res: 2, luck: 8, mag: 0}

        @growthRates = {maxHp: .7, maxMp: 1, str: .5, skill: .35,
        speed: .35, luck: .5, def: .4, res: .15}

        super()

class _uclass.special.Arrow extends _uclass.Archer
    constructor: ->
        @name = 'Arrow'
        @level = 1
        @picture = true
        @inventory = [new _item.IronBow()]
        @inventory.push(new _item.IronBow())

        @skills = [new _skill.FirstAid()]

        @startStats = {maxHp: 24, maxMp: 10, str: 4, def: 4,
        skill: 4.0, speed: 4.1, res: 2, luck: 2, mag: 2}

        @growthRates = {maxHp: .65, maxMp: 1, str: .4, skill: .45,
        speed: .45, luck: .6, def: .25, res: .15, mag: .4}

        super()

class _uclass.special.Luciana extends _uclass.Soldier
    constructor: ->
        @name = 'Luciana'
        @level = 3
        @picture = true
        @inventory = [new _item.IronLance()]
        @inventory.push(new _item.IronBow())
        @skills = [new _skill.Protect()]

        @startStats = {maxHp: 28, maxMp: 10, str: 3.5, def: 6,
        skill: 3.8, speed: 3.2, res: 2, luck: 4, mag: 0}

        @growthRates = {maxHp: .8, maxMp: 1, str: .4, skill: .35,
        speed: .35, luck: .3, def: .5, res: .15}

        super()

class _uclass.special.Kenji extends _uclass.Fighter
    constructor: ->
        @name = 'Kenji'
        @level = 2
        @picture = true
        @inventory = [new _item.IronAxe()]
        @skills = [new _skill.Temper()]

        @startStats = {maxHp: 36, maxMp: 10, str: 7, def: 3.5,
        skill: 4, speed: 5, res: 2, luck: 4, mag: 0}

        @growthRates = {maxHp: .8, maxMp: 1, str: .5, skill: .35,
        speed: .35, luck: .45, def: .35, res: .15}

        super()

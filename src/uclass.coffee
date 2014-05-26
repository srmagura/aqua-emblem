window.uclass = {special: {}}

class window.uclass.Mercenary extends Unit
    constructor: (attr) ->
        @uclassName = 'Mercenary'
        @wield = [item.Sword]

        @baseStats = {baseHp: 18, move: 5, str: 4, def: 2,
        skill: 4, speed: 6, res: 1, luck: 2, aid: 7, con: 5,
        mag: 0}

        @growthRates = {baseHp: .8, str: .5, skill: .35,
        speed: .35, luck: .1, def: .25, res: .15}

        super(attr)

class window.uclass.Archer extends Unit
    constructor: (attr) ->
        @uclassName = 'Archer'
        @wield = [item.Bow]

        @baseStats = {baseHp: 18, move: 5, str: 4, def: 2,
        skill: 5, speed: 6, res: 1, luck: 2, aid: 7, con: 5,
        mag: 0}

        @growthRates = {baseHp: .65, str: .4, skill: .45,
        speed: .40, luck: .1, def: .25, res: .15}

        super(attr)


class window.uclass.special.Ace extends uclass.Mercenary
    constructor: ->
        attr = {name: 'Ace', baseHp: 22, baseMp: 5,
        move: 4, str: 7, def: 3,
        skill: 4, speed: 4, res: 2, luck: 8, aid: 7, con: 5,
        mag: 0, level: 1, picture: true, lord: true,
        inventory: [new item.IronSword()]}

        super(attr)

class window.uclass.special.Arrow extends uclass.Archer
    constructor: ->
        attr = {name: 'Arrow', baseHp: 18, baseMp: 5,
        move: 4, str: 5, def: 4,
        skill: 5, speed: 6, res: 2, luck: 5, aid: 7, con: 5,
        mag: 0, level: 1, picture: true,
        inventory: [new item.IronBow()]}

        super(attr)

class _item.IronBow extends _item.Bow

    constructor: ->
        super()
        @name = 'Iron bow'
        @hit = 85
        @might = 6
        @weight = 5
        
class _item.SteelBow extends _item.Bow

    constructor: ->
        super()
        @name = 'Steel bow'
        @image = 'steel_bow.png'
        @hit = 75
        @might = 9
        @weight = 5
        @uses = _item.uses.steel
       
class _item.KillerBow extends _item.Bow

    constructor: ->
        super()
        @name = 'Killer bow'
        @image = 'killer_bow.png'
        @hit = 75
        @might = 7
        @weight = 7
        @crit = 30
        @uses = _item.uses.killer

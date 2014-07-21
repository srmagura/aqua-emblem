class _item.IronBow extends _item.Bow

    constructor: ->
        super()
        @name = 'Iron bow'
        @hit = 85
        @might = 6
        @weight = 5
        
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

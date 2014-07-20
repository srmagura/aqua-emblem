class _item.IronSword extends _item.Sword

    constructor: ->
        super()
        @name = 'Iron sword'
        @hit = 90
        @might = 5
        @weight = 5
        
class _item.SteelSword extends _item.Sword

    constructor: ->
        super()
        @name = 'Steel sword'
        @image = 'steel_sword.png'
        @hit = 80
        @might = 8
        @weight = 8
        @uses = _item.uses.steel

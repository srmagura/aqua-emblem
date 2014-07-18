class _item.IronLance extends _item.Lance

    constructor: ->
        super()
        @name = 'Iron lance'
        @hit = 80
        @might = 7
        @weight = 8
        
class _item.SteelLance extends _item.Lance

    constructor: ->
        super()
        @name = 'Steel lance'
        @image = 'steel_lance.png'
        @hit = 70
        @might = 10
        @weight = 11
        @uses = _item.uses.steel

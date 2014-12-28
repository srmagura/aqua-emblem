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
        @weight = 8
        @uses = _item.uses.steel
        
class _item.BraveLance extends _item.Lance
    
    constructor: ->
        super()
        @name = 'Brave lance'
        @image = 'brave_lance.png'
        @hit = 80
        @might = 7
        @weight = 8
        @nAttackMultiplier = 2
        @uses = _item.uses.brave
        
    hasUses: (x) -> true

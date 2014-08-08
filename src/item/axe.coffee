class _item.IronAxe extends _item.Axe

    constructor: ->
        super()
        @name = 'Iron axe'
        @hit = 75
        @might = 8
        @weight = 10
        
class _item.SteelAxe extends _item.Axe

    constructor: ->
        super()
        @name = 'Steel axe'
        @image = 'steel_axe.png'
        @hit = 65
        @might = 11
        @weight = 10
        @uses = _item.uses.steel
        
class _item.HandAxe extends _item.Axe

    constructor: ->
        super()
        @name = 'Hand axe'
        @image = 'hand_axe.png'
        @hit = 60
        @might = 8
        @weight = 8
        @uses = 20
        @range = new Range(1, 2)

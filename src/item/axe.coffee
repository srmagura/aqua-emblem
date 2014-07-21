class _item.IronAxe extends _item.Axe

    constructor: ->
        super()
        @name = 'Iron axe'
        @hit = 75
        @might = 8
        @weight = 10
        
class _item.HandAxe extends _item.Axe

    constructor: ->
        super()
        @name = 'Hand axe'
        @image = 'hand_axe.png'
        @hit = 60
        @might = 8
        @weight = 8
        @uses = 25
        @range = new Range(1, 2)

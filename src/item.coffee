window.item = {}

class item.Item

    getElement: ->
        el = $('<div class="weapon-element"></div>')

        src = "images/items/#{@image}"
        el.append($("<img src='#{src}' />"))
        el.append($("<span>#{@name}</span>"))
        return el

class item.Weapon extends item.Item

    constructor: ->
        super()

class item.Sword extends item.Weapon

    constructor: ->
        @image = 'iron_sword.png'
        @range = [1]
        super()

class item.IronSword extends item.Sword

    constructor: ->
        @name = 'Iron sword'
        @hit = 85
        @might = 4
        @weight = 2
        @crit = 0
        super()

class item.Bow extends item.Weapon

    constructor: ->
        @image = 'iron_bow.png'
        @range = [2]
        super()

class item.IronBow extends item.Bow

    constructor: ->
        @name = 'Iron bow'
        @hit = 85
        @might = 4
        @weight = 2
        @crit = 0
        super()

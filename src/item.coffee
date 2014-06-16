window.item = {}

class item.Item

    getElement: (usable=true) ->
        el = $('<div class="item-element"></div>')

        if not usable
            el.addClass('not-usable')

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
        @hit = 90
        @might = 5
        @weight = 5
        @crit = 0
        super()

class item.Lance extends item.Weapon

    constructor: ->
        @image = 'iron_lance.png'
        @range = [1]
        super()

class item.IronLance extends item.Lance

    constructor: ->
        @name = 'Iron lance'
        @hit = 80
        @might = 7
        @weight = 8
        @crit = 0
        super()

class item.Axe extends item.Weapon

    constructor: ->
        @image = 'iron_axe.png'
        @range = [1]
        super()

class item.IronAxe extends item.Axe

    constructor: ->
        @name = 'Iron axe'
        @hit = 75
        @might = 8
        @weight = 10
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
        @might = 6
        @weight = 5
        @crit = 0
        super()


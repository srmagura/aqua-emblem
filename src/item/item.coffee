window._item = {}

class _item.Item

    getElement: (usable=true) ->
        el = $('<div class="item-element"></div>')

        if not usable
            el.addClass('not-usable')

        src = @getImagePath()
        el.append($("<img src='#{src}' />"))
        el.append($("<span>#{@name}</span>"))
        el.data('item', this)
        return el

    getImagePath: -> "images/items/#{@image}"
    
    pickle: ->
        return {
            constructor: @constructor.name
        }
        
    @unpickle: (pickled) ->
        if pickled.constructor of _item
            constructor = _item[pickled.constructor]
            item = new constructor()
        else
            return null
            
        return item

class _item.Weapon extends _item.Item

    constructor: ->
        super()

class _item.Sword extends _item.Weapon

    constructor: ->
        @type = new _skill.type.Sword()
        @image = 'iron_sword.png'
        @range = new Range(1)
        super()

class _item.IronSword extends _item.Sword

    constructor: ->
        @name = 'Iron sword'
        @hit = 90
        @might = 5
        @weight = 5
        @crit = 0
        super()

class _item.Lance extends _item.Weapon

    constructor: ->
        @type = new _skill.type.Lance()
        @image = 'iron_lance.png'
        @range = new Range(1)
        super()

class _item.IronLance extends _item.Lance

    constructor: ->
        @name = 'Iron lance'
        @hit = 80
        @might = 7
        @weight = 8
        @crit = 0
        super()

class _item.Axe extends _item.Weapon

    constructor: ->
        @type = new _skill.type.Axe()
        @image = 'iron_axe.png'
        @range = new Range(1)
        super()

class _item.IronAxe extends _item.Axe

    constructor: ->
        @name = 'Iron axe'
        @hit = 75
        @might = 8
        @weight = 10
        @crit = 0
        super()

class _item.Bow extends _item.Weapon

    constructor: ->
        @type = new _skill.type.Bow()
        @image = 'iron_bow.png'
        @range = new Range(2)
        super()

class _item.IronBow extends _item.Bow

    constructor: ->
        @name = 'Iron bow'
        @hit = 85
        @might = 6
        @weight = 5
        @crit = 0
        super()


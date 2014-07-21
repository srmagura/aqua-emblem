window._item = {}

_item.uses = {
    steel: 30,
    killer: 20,
}

class _item.Item

    constructor: ->
        @drop = false
        
    letDrop: -> 
        @drop = true
        return this
        
    hasUses: (n) -> (@uses is null or @uses >= n) 

    getElement: (options={}) ->
        el = $('<div class="item-element"></div>')
        
        html = @name
        if 'equipped' of options and options.equipped
            html += ' <span class="equipped">(E)</span>' 

        if 'usable' of options and not options.usable
            el.addClass('not-usable')
        
        if @drop
            el.addClass('drop')

        src = @getImagePath()
        el.append($("<img src='#{src}' />"))
        el.append($("<span class='text'>#{html}</span>"))
        
        if @uses? and not ('showUses' of options and not options.showUses)
            el.append($("<div class='uses'>#{@uses}</div>"))
        
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
        @crit = 0
        @uses = null
        super()

class _item.Sword extends _item.Weapon

    constructor: ->
        @type = new _skill.type.Sword()
        @image = 'iron_sword.png'
        @range = new Range(1)
        super()

class _item.Lance extends _item.Weapon

    constructor: ->
        @type = new _skill.type.Lance()
        @image = 'iron_lance.png'
        @range = new Range(1)
        super()

class _item.Axe extends _item.Weapon

    constructor: ->
        @type = new _skill.type.Axe()
        @image = 'iron_axe.png'
        @range = new Range(1)
        super()

class _item.Bow extends _item.Weapon

    constructor: ->
        @type = new _skill.type.Bow()
        @image = 'iron_bow.png'
        @range = new Range(2)
        super()


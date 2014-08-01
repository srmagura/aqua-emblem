class _unit.Inventory

    @MAX_SIZE: 5

    constructor: (@unit, @items) ->
        @refresh()
   
    set: (i, item) ->
        @items[i] = item
        @refresh()
        
    push: (item) -> @items.push(item)
        
    get: (i) -> @items[i]
                
    it: -> @items.slice(0, @items.length)
    
    size: -> @items.length

    remove: (arg) ->
        if arg instanceof _item.Item
            i = @items.indexOf(arg)
        else
            i = arg
            
        @items.splice(i, 1)
        @refresh()
        
    setEquipped: (item) ->
        i = @items.indexOf(item)
        @items.splice(i, 1)
        @items = [item].concat(@items)
        @refresh()

    refresh: ->
        totalRange = new Range()
        
        equippedSet = false
        
        for item in @items
            if @unit.canWield(item)
                if not equippedSet
                    @unit.equipped = item
                    equippedSet = true

                totalRange = totalRange.union(item.range)
                
        @unit.totalRange = totalRange
        
        if not equippedSet
            @unit.equipped = null
            
        @unit.calcCombatStats()
            
    pickle: ->
        array = []
        for item in @items
            array.push(item.pickle())
            
        return array
        
    @unpickle: (pickled, unit) ->
        if not pickled?
            return null
    
        items = []
        
        for pickledItem in pickled
            item = _item.Item.unpickle(pickledItem)
            if item is null
                return null
            else
                items.push(item)
                
        return new _unit.Inventory(unit, items)

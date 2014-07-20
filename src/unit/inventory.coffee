class _unit.Inventory

    @MAX_SIZE: 5

    constructor: (@unit, @items) ->
        @refresh()
   
    set: (i, item) ->
        @items[i] = item
        @refresh()
        
    get: (i) -> @items[i]
                
    it: -> @items
    
    size: -> @items.length

    remove: (i) ->
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

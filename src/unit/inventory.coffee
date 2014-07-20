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

    refresh: ->
        totalRange = new Range()
        
        for item in @items
            if @unit.canWield(item)
                if not @unit.equipped? or @unit.equipped instanceof _skill.Skill
                    @unit.equipped = item

                totalRange = totalRange.union(item.range)
                
        @unit.totalRange = totalRange
        
        newItems = [@unit.equipped]
        for item in @items
            if not item is @unit.equipped
                newItems.push(item)
                
        @items = newItems


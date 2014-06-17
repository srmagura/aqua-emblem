class window.TradeWindow

    constructor: (@ui) ->
        @window = $('.trade-window')

    init: (@unit1, @unit2) ->
        @window.html('')

        @initHalf(@unit1)
        @initHalf(@unit2)

        @ui.viewportOverlay.show()
        css = @ui.centerElement(@window, 0)
        @window.css(css)
        @show()

    initHalf: (unit) ->
        container = $('<div></div>').addClass('half')
        container.addClass('half-' + unit.id)

        top = $('<div></div>').addClass('top')
        img = $('<img/>').attr('src', unit.getImagePath())
        img.appendTo(top)
        top.appendTo(container)

        inventory = $('<div></div>')
        inventory.addClass('inventory neutral-box')
        @fillInventory(unit, inventory)
        inventory.appendTo(container)

        container.appendTo(@window)

    fillInventory: (unit, inventoryEl=null) ->
        if not inventoryEl?
            sel = ".trade-window .half-#{unit.id} .inventory"
            inventoryEl = $(sel)
            
        for i in [0 .. Unit.INVENTORY_SIZE-1]
            itemContainer = $('<div></div>').addClass('item-container')
            arrowImg = $('<div></div>').addClass('arrow-image')
            arrowImg.appendTo(itemContainer)

            item = unit.inventory[i]
            if item?
                usable = unit.canUse(item)
                itemContainer.append(item.getElement(usable))

            inventoryEl.append(itemContainer)

    show: ->
        @window.css('visibility', 'visible')

    hide: ->
        @window.css('visibility', 'hidden')

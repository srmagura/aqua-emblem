class window.TradeWindow

    constructor: (@ui) ->
        @window = $('.trade-window')

    init: (unit0, unit1) ->
        @units = [unit0, unit1]
        @window.html('')

        @initHalf(unit0)
        @initHalf(unit1)

        @setCursorPos(new Position(0, 0))

        @ui.controlState = new CsTradeWindow(@ui, this)
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
            sel = ".half-#{unit.id} .inventory"
            inventoryEl = @window.find(sel)
            
        for i in [0 .. Unit.INVENTORY_SIZE-1]
            itemContainer = $('<div></div>').addClass('item-container')
            arrowImg = $('<div></div>').addClass('arrow-image')
            arrowImg.appendTo(itemContainer)

            item = unit.inventory[i]
            if item?
                usable = unit.canUse(item)
                itemContainer.append(item.getElement(usable))

            inventoryEl.append(itemContainer)

    setCursorPos: (@cursorPos) ->
        @window.find('.arrow-image.cursor-at').removeClass('cursor-at')

        half = $(@window.find('.half')[@cursorPos.j])
        itemContainer = $(half.find('.item-container')[@cursorPos.i])
        itemContainer.find('.arrow-image').addClass('cursor-at')

    moveCursor: (delta) ->
        @setCursorPos(@cursorPos.add(delta))

    show: ->
        @window.css('visibility', 'visible')

    hide: ->
        @window.css('visibility', 'hidden')


class CsTradeWindow extends ControlState

    constructor: (@ui, @windowObj) ->

    up: ->
        if @windowObj.cursorPos.i > 0
            @windowObj.moveCursor(new Position(-1, 0))

    down: ->
        cp = @windowObj.cursorPos
        unit = @windowObj.units[cp.j]

        if cp.i + 1 < unit.inventory.length
            @windowObj.moveCursor(new Position(1, 0))

    left: ->
        if @windowObj.cursorPos.j == 1
            @windowObj.moveCursor(new Position(0, -1))

    right: ->
        if @windowObj.cursorPos.j == 0
            @windowObj.moveCursor(new Position(0, 1))


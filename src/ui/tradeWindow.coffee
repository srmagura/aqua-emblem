class window.TradeWindow

    constructor: (@ui) ->
        @window = $('.trade-window')

    init: (unit0, unit1) ->
        @units = [unit0, unit1]
        @window.html('')

        @initHalf(unit0, 0)
        @initHalf(unit1, 1)

        @setCursorPos(new Position(0, 0))

        @prevControlState = @ui.controlState
        @ui.controlState = new CsTradeWindow(@ui, this)
        @ui.viewportOverlay.show()

        css = @ui.centerElement(@window, 0)
        @window.css(css)
        @show()

    initHalf: (unit, j) ->
        container = $('<div></div>').addClass('half')
        container.addClass('half-' + unit.id)

        top = $('<div></div>').addClass('top')
        img = $('<img/>').attr('src', unit.getImagePath())
        img.appendTo(top)
        top.appendTo(container)

        inventory = $('<div></div>')
        inventory.addClass('inventory neutral-box')
        @fillInventory(unit, inventory, j)
        inventory.appendTo(container)

        container.appendTo(@window)

    fillInventory: (unit, inventoryEl, j) ->
        if not inventoryEl?
            sel = ".half-#{unit.id} .inventory"
            inventoryEl = @window.find(sel)
            
        for i in [0 .. Unit.INVENTORY_SIZE-1]
            itemContainer = $('<div></div>').addClass('item-container')
            itemContainer.data('pos', new Position(i, j))
            arrowImg = $('<div></div>').addClass('arrow-image')
            arrowImg.appendTo(itemContainer)

            item = unit.inventory[i]
            if item?
                usable = unit.canUse(item)
                itemContainer.append(item.getElement(usable))

            inventoryEl.append(itemContainer)

    # Return an item-container
    getCursorEl: ->
        half = $(@window.find('.half')[@cursorPos.j])
        return $(half.find('.item-container')[@cursorPos.i])

    setCursorPos: (@cursorPos) ->
        @window.find('.arrow-image.cursor-at').removeClass('cursor-at')
        @getCursorEl().find('.arrow-image').addClass('cursor-at')

    moveCursor: (delta) ->
        @setCursorPos(@cursorPos.add(delta))

    doSelect: ->
        @getCursorEl().addClass('selected')
        @cursorPos.j = (@cursorPos.j + 1) % 2
        @setCursorPos(@cursorPos)
        @ui.controlState = new CsTradeWindow2(@ui, this)

    doDeselect: ->
        selected = @window.find('.item-container.selected')
        @setCursorPos(selected.data('pos'))
        selected.removeClass('selected')
        @ui.controlState = new CsTradeWindow(@ui, this)

    show: ->
        @window.css('visibility', 'visible')

    hide: ->
        @ui.viewportOverlay.hide()

        hide = {'visibility': 'hidden'}
        @window.css(hide)
        @window.find('.arrow-image').css(hide)


class CsTradeWindow extends ControlState

    constructor: (@ui, @windowObj) ->

    f: ->
        @windowObj.doSelect()

    d: ->
        @windowObj.hide()
        @ui.controlState = @windowObj.prevControlState

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

class CsTradeWindow2 extends ControlState

    constructor: (@ui, @windowObj) ->

    f: ->

    d: ->
        @windowObj.doDeselect()

    up: ->
        if @windowObj.cursorPos.i > 0
            @windowObj.moveCursor(new Position(-1, 0))

    down: ->
        cp = @windowObj.cursorPos
        unit = @windowObj.units[cp.j]

        if cp.i + 1 < Unit.INVENTORY_SIZE and
        cp.i < unit.inventory.length
            @windowObj.moveCursor(new Position(1, 0))

class _chapterui.TradeWindow

    constructor: (@ui) ->
        @window = $('.trade-window')

    init: (unit0, unit1, @callback) ->
        @units = [unit0, unit1]
        @tradeMade = false

        @window.html('')

        @initHalf(unit0, 0)
        @initHalf(unit1, 1)

        @setCursorPos(new Position(0, 0))

        @prevControlState = @ui.controlState
        @ui.controlState = new _cs.chapterui.TradeWindow(@ui, this)
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
            
        inventoryEl.html('')
        for i in [0 .. _unit.Inventory.MAX_SIZE-1]
            itemContainer = $('<div></div>').addClass('item-container')
            itemContainer.data('pos', new Position(i, j))
            arrowImg = $('<div></div>').addClass('arrow-image')
            arrowImg.appendTo(itemContainer)

            item = unit.inventory.get(i)
            if item?
                options = {usable: unit.canUse(item)}
                
                itemContainer.append(item.getElement(options))
                itemContainer.data('item', item)

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
        @selectedEl = @getCursorEl().addClass('selected')
        @cursorPos.i = 0
        @cursorPos.j = (@cursorPos.j + 1) % 2
        @setCursorPos(@cursorPos)
        @ui.controlState = new _cs.chapterui.TradeWindow2(@ui, this)

    doDeselect: ->
        selected = @window.find('.item-container.selected')
        @setCursorPos(selected.data('pos'))
        selected.removeClass('selected')
        @ui.controlState = new _cs.chapterui.TradeWindow(@ui, this)

    doTrade: ->
        @tradeMade = true
        unitFrom = @units[(@cursorPos.j + 1) % 2]
        unitTo = @units[@cursorPos.j]

        iFrom = @selectedEl.data('pos').i
        if @cursorPos.i == unitTo.inventory.size()
            unitFrom.inventory.remove(iFrom)
        else
            unitFrom.inventory.set(iFrom, @getCursorEl().data('item'))

        unitTo.inventory.set(@cursorPos.i, @selectedEl.data('item'))

        @fillInventory(@units[0], null, 0)
        @fillInventory(@units[1], null, 1)
        @setCursorPos(@cursorPos)
        @ui.controlState = new _cs.chapterui.TradeWindow(@ui, this)

    show: ->
        @window.css('visibility', 'visible')

    hide: ->
        @ui.viewportOverlay.hide()

        hide = {'visibility': 'hidden'}
        @window.css(hide)
        @window.find('.arrow-image').css(hide)


class _cs.chapterui.TradeWindow extends _cs.chapterui.Chapter

    constructor: (@ui, @windowObj) ->

    f: ->
        @windowObj.doSelect()

    d: ->
        @windowObj.hide()
        @ui.controlState = @windowObj.prevControlState
        @windowObj.callback(@windowObj.tradeMade)

    up: ->
        cp = @windowObj.cursorPos
        if cp.i > 0
            @windowObj.moveCursor(new Position(-1, 0))
        else
            unit = @windowObj.units[cp.j]
            cp.i = unit.inventory.size() - 1
            @windowObj.setCursorPos(cp)

    down: ->
        cp = @windowObj.cursorPos
        unit = @windowObj.units[cp.j]

        if cp.i + 1 < unit.inventory.size()
            @windowObj.moveCursor(new Position(1, 0))
        else
            cp.i = 0
            @windowObj.setCursorPos(cp)

    left: ->
        cp = @windowObj.cursorPos
        if cp.j == 1
            len = @windowObj.units[0].inventory.size()
            if cp.i >= len
                cp.i = len - 1
                @windowObj.setCursorPos(cp)

            @windowObj.moveCursor(new Position(0, -1))

    right: ->
        cp = @windowObj.cursorPos
        if cp.j == 0
            len = @windowObj.units[1].inventory.size()
            if cp.i >= len
                cp.i = len - 1
                @windowObj.setCursorPos(cp)

            @windowObj.moveCursor(new Position(0, 1))

class _cs.chapterui.TradeWindow2 extends _cs.chapterui.Chapter

    constructor: (@ui, @windowObj) ->

    f: ->
        @windowObj.doTrade()

    d: ->
        @windowObj.doDeselect()

    up: ->
        cp = @windowObj.cursorPos
        unit = @windowObj.units[cp.j]

        if cp.i > 0
            @windowObj.moveCursor(new Position(-1, 0))
        else
            cp.i = unit.inventory.size()
            @windowObj.setCursorPos(cp)

    down: ->
        cp = @windowObj.cursorPos
        unit = @windowObj.units[cp.j]

        if cp.i + 1 < _unit.Inventory.MAX_SIZE and
        cp.i < unit.inventory.size()
            @windowObj.moveCursor(new Position(1, 0))
        else
            cp.i = 0
            @windowObj.setCursorPos(cp)

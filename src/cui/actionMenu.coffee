class _cui.ActionMenu

    constructor: (@ui) ->
        @menu = $('.action-menu')

    init: (unit, menuItems) ->
        if unit?
            @unit = unit

        if menuItems?
            @menuItems = menuItems
            @menu.html('')
            for item, k in menuItems
                el = $('<div><div class="image"></div></div>')
                el.data('index', k).append(item.name).
                    appendTo('.action-menu')

            @menu.children('div').first().addClass('selected')

        @ui.cursor.visible = false
        @ui.controlState = new _cs.ActionMenu(@ui, this)
        @show()

        @ui.chapter.map.setOverlayRange(@unit.pos,
        @unit.totalRange, 'ATTACK')

    show: ->
        @menu.css('display', 'inline-block')

    hide: ->
        @menu.css('display', 'none')

class _cui.ActionMenuItem
    constructor: (@name, @handler) ->

class _cs.Menu extends _cs.Chapter

    constructor: (@ui, @menuObj) ->

    onChange: ->

    up: ->
        sel = @menuObj.menu.find('.selected')
        sel.removeClass('selected')

        if sel.prev().size() != 0
            sel.prev().addClass('selected')
        else
            @menuObj.menu.children('div').last().
                addClass('selected')

        @onChange()

    down: ->
        sel = @menuObj.menu.find('.selected')
        sel.removeClass('selected')

        if sel.next().size() != 0
            sel.next().addClass('selected')
        else
            @menuObj.menu.children('div').first().
                addClass('selected')

        @onChange()

class _cs.ActionMenu extends _cs.Menu

    f: ->
        k = @menuObj.menu.find('.selected').data('index')
        @menuObj.hide()
        @ui.controlState = new _cs.Map(@ui)

        @menuObj.menuItems[k].handler()

    d: ->
        @ui.actionMenu.hide()
        @ui.controlState = new _cs.Map(@ui)

        ch = @ui.chapter
        unit = ch.playerTurn.selectedUnit
        unit.pos = unit.oldPos
        ch.playerTurn.deselect()
        
        @ui.cursor.visible = true
        @ui.cursor.moveTo(unit.pos.clone())

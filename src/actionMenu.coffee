class window.ActionMenu

    constructor: (@ui) ->
        @menu = $('.action-menu')

    init: (@menuItems) ->
        @menu.html('')
        for item, k in menuItems
            el = $('<div><div class="image"></div></div>')
            el.data('index', k).append(item.name).
                appendTo('.action-menu')

        @menu.children('div').first().addClass('selected')

        @ui.cursor.visible = false
        @ui.controlState = new CsActionMenu(@ui, this)
        @show()

    show: ->
        @menu.css('display', 'inline-block')

    hide: ->
        @menu.css('display', 'none')

class window.ActionMenuItem
    constructor: (@name, @handler) ->

class CsMenu extends ControlState

    constructor: (@ui, @menuObj) ->

    up: ->
        sel = @menuObj.menu.find('.selected')
        sel.removeClass('selected')

        if sel.prev().size() != 0
            sel.prev().addClass('selected')
        else
            @menuObj.menu.children('div').last().
                addClass('selected')

    down: ->
        sel = @menuObj.menu.find('.selected')
        sel.removeClass('selected')

        if sel.next().size() != 0
            sel.next().addClass('selected')
        else
            @menuObj.menu.children('div').first().
                addClass('selected')

class window.CsActionMenu extends CsMenu

    f: ->
        k = @menuObj.menu.find('.selected').data('index')
        @menuObj.hide()
        @ui.controlState = new CsMap(@ui)

        @menuObj.menuItems[k].handler()

    d: ->
        @ui.actionMenu.hide()
        @ui.controlState = new CsMap(@ui)

        ch = @ui.chapter
        unit = ch.playerTurn.selectedUnit
        unit.pos = unit.oldPos
        
        @ui.cursor.visible = true
        @ui.cursor.moveTo(unit.pos.clone())



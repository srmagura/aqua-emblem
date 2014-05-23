class window.ActionMenu

    constructor: (@ui) ->
        @menu = $('.action-menu')

    init: (@menuItems) ->
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

    constructor: (@ui, @actionMenu) ->

class CsActionMenu extends CsMenu

    f: ->
        k = @actionMenu.menu.find('.selected').data('index')
        @actionMenu.hide()
        @ui.controlState = new CsMap(@ui)

        @actionMenu.menuItems[k].handler()

    d: ->
        @ui.actionMenu.hide()
        @ui.controlState = new CsMap(@ui)

        ch = @ui.chapter
        unit = ch.playerTurn.selectedUnit
        unit.pos = unit.oldPos
        
        @ui.cursor.visible = true
        @ui.cursor.moveTo(unit.pos.clone())



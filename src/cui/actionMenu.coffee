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
        @ui.controlState = new _cs.cui.ActionMenu(@ui, this)
        @show()

        @ui.chapter.map.setOverlayRange(@unit.pos,
        @unit.totalRange, 'ATTACK')

    show: ->
        @menu.css('display', 'inline-block')

    hide: ->
        @menu.css('display', 'none')

class _cui.ActionMenuItem
    constructor: (@name, @handler) ->


class _cs.cui.ActionMenu extends _cs.cui.Menu

    f: ->
        k = @menuObj.menu.find('.selected').data('index')
        @menuObj.hide()
        @ui.controlState = new _cs.cui.Map(@ui)

        @menuObj.menuItems[k].handler()

    d: ->
        @ui.actionMenu.hide()
        @ui.controlState = new _cs.cui.Map(@ui)

        ch = @ui.chapter
        unit = ch.playerTurn.selectedUnit
        unit.pos = unit.oldPos
        ch.playerTurn.deselect()
        
        @ui.cursor.visible = true
        @ui.cursor.moveTo(unit.pos.clone())

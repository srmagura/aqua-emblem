class _cui.ActionMenu

    constructor: (@ui) ->

    init: (menuItems) ->
        if menuItems?
            @menu.html('')
            for item in menuItems
                el = $('<div><div class="image"></div></div>')
                el.append(item.name).appendTo(@menu)
                el.data('handler', item.handler)

            @menu.children('div').first().addClass('selected')

        @show()


    show: ->
        @menu.css('display', 'inline-block')

    hide: ->
        @menu.css('display', 'none')


class _cui.ActionMenuItem

    constructor: (@name, @handler) ->


class _cui.ActionMenuMain extends _cui.ActionMenu

    constructor: (@ui) ->
        super(@ui)
        @menu = $('.action-menu')   

    init: (unit, menuItems) ->
        super(menuItems)
        
        if unit?
            @unit = unit
            
        @ui.cursor.visible = false
        @ui.controlState = new _cs.cui.ActionMenuMain(@ui, this)
        
        @ui.chapter.map.setOverlayRange(@unit.pos,
        @unit.totalRange, 'ATTACK')


class _cs.cui.ActionMenuMain extends _cs.cui.Menu

    f: ->
        @menuObj.hide()
        @ui.controlState = new _cs.cui.Map(@ui)

        handler = @menuObj.menu.find('.selected').data('handler')
        handler()

    d: ->
        @ui.actionMenu.hide()
        @ui.controlState = new _cs.cui.Map(@ui)

        ch = @ui.chapter
        unit = ch.playerTurn.selectedUnit
        unit.pos = unit.oldPos
        ch.playerTurn.deselect()
        
        @ui.cursor.visible = true
        @ui.cursor.moveTo(unit.pos.clone())

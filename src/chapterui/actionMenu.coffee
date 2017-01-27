class _chapterui.ActionMenu

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

    callSelectedHandler: ->
        handler = @menu.find('.selected').data('handler')
        handler()

    show: ->
        @menu.css('display', 'inline-block')

    hide: ->
        @menu.css('display', 'none')


class _chapterui.ActionMenuItem

    constructor: (@name, @handler) ->


class _chapterui.ActionMenuMain extends _chapterui.ActionMenu

    constructor: (@ui) ->
        super(@ui)
        @menu = $('.action-menu')   

    init: (unit, menuItems) ->
        super(menuItems)
        
        if unit?
            @unit = unit
            
        @ui.cursor.visible = false
        @ui.controlState = new _cs.chapterui.ActionMenuMain(@ui, this)
        
        @ui.chapter.map.setOverlayRange(@unit.pos,
        @unit.totalRange, 'ATTACK')


class _cs.chapterui.ActionMenuMain extends _cs.chapterui.Menu

    f: ->
        @menuObj.hide()
        @ui.controlState = new _cs.chapterui.Map(@ui)

        @menuObj.callSelectedHandler()

    d: ->
        @ui.actionMenu.hide()
        @ui.controlState = new _cs.chapterui.Map(@ui)

        ch = @ui.chapter
        unit = ch.playerTurn.selectedUnit
        unit.pos = unit.oldPos
        ch.playerTurn.deselect()
        
        @ui.cursor.visible = true
        @ui.cursor.moveTo(unit.pos.clone())

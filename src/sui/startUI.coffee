window._sui = {}
_cs.sui = {}

class _sui.StartUI extends UI

    constructor: ->
        super()
        @vn = $('.vn-wrapper')
        @controlState = new _cs.ControlState(this)
        @wrapper = @vn.find('.start-menu-container')
        @itemContainer = @wrapper.find('.items')

    init: (options={}) ->
        @itemContainer.html('')
        @wrapper.show()
        _vn.setBackgroundImage(@wrapper, 'start')

        if 'menuCls' of options
            menuCls = options.menuCls
        else
            menuCls = _sui.MenuMain

        next = => @initMenu(menuCls)

        if 'fade' of options and options.fade
            @vn.fadeIn(1000, next)
        else
            @vn.show()
            next()

    initMenu: (menuCls) ->
        @menu = new menuCls(this, @itemContainer)
        @menu.init()
        @controlState = new _cs.sui.Menu(this, @menu)

    destroy: ->
        @wrapper.hide()
        @vn.hide()

class _sui.Menu

    constructor: (@ui, @menu) ->

    getMenuEl: (mainText, subtext='') ->
        el = $('<div></div>').addClass('menu-item')
        $('<div></div>').addClass('main-text').html(mainText).appendTo(el)
        $('<div></div>').addClass('subtext').html(subtext).appendTo(el)
        return el

    selectFirst: ->
        @menu.children().first().addClass('selected')

    getSelected: ->
        return @menu.find('.selected')

    back: ->


class _cs.sui.Menu extends _cs.Menu
    
    f: ->
        @menuObj.getSelected().data('handler')()

    d: ->
        @menuObj.back()

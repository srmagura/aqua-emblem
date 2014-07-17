window._sui = {}
_cs.sui = {}

class _sui.StartUI extends UI

    constructor: (@file) ->
        super()
        @vn = $('.vn-wrapper')
        @controlState = new _cs.ControlState(this)
        
        @wrapper = @vn.find('.start-menu-container')
        @itemContainer = @wrapper.find('.items')
        @messageDiv = @wrapper.find('.message')
        
        @saveBackupDialog = @wrapper.find('.save-backup')
        @uploadDialog = @wrapper.find('.upload-backup')
        
        @messages = {
            'chapterComplete': 'Chapter complete! Game saved.'
        }
        
        @dialogOptions = {modal: true, width: 400, close: @dialogOnClose}

    init: (options={}) ->
        @itemContainer.html('')
        @wrapper.show()
        _vn.setBackgroundImage(@wrapper, 'start')

        next = => 
            if @file?
                @initMenu(_sui.MenuMain)
            else
                @initMenu(_sui.MenuNoData)
                       
            if 'message' of options
                @messageDiv.html(options.message).show()

        if 'fade' of options and options.fade
            @vn.fadeIn(1000, next)
        else
            @vn.show()
            next()

    initMenu: (menuCls) ->
        @messageDiv.hide()
        @itemContainer.html('')
        
        @menu = new menuCls(this, @itemContainer)
        @menu.init()
        @controlState = new _cs.sui.Menu(this, @menu)
        
    dialogOnClose: =>
        @uploadDialog.find('textarea').attr('readonly', 'readonly')
        @controlState = @prevControlState

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

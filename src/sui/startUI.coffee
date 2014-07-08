window._sui = {}
_cs.sui = {}

class _sui.StartUI extends UI

    constructor: ->
        super()
        @vn = new VisualNovel()
        @vn.show()
        @controlState = new _cs.ControlState(this)

    init: ->
        @vn.setBackgroundImage('images/start_background.png')
        @menuContainer = $('<div></div').
            addClass('start-menu-container').
            appendTo(@vn.wrapper)
        @initMenu(_sui.StartMenuMain)

    initMenu: (menuCls) ->
        @menu = new menuCls(this, @menuContainer)
        @menu.init()
        @controlState = new _cs.sui.StartMenu(this, @menu)

    destroy: ->
        @menuContainer.remove()
        @vn.setBackgroundImage('')
        @vn.hide()

class _sui.StartMenu

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

class _sui.StartMenuMain extends _sui.StartMenu

    init: ->
        @menu.html('')

        @getMenuEl('New game').appendTo(@menu).
            data('handler', @handleNewGame)
        @selectFirst()
        @controlState = new _cs.sui.StartMenu(this, @menu)

    handleNewGame: =>
        @ui.initMenu(_sui.StartMenuDifficulty)

class _sui.StartMenuDifficulty extends _sui.StartMenu

    init: ->
        @menu.html('')

        normal = @getMenuEl('Normal',
            'The default difficulty.')
        normal.appendTo(@menu).data('handler', @handler)
        normal.data('difficulty', _file.difficulty.normal)

        hard = @getMenuEl('Hard',
            'How Aqua Emblem is meant to be played. ' +
            'Units start at a lower ' +
            'level and gain experience more slowly.')
        hard.appendTo(@menu).data('handler', @handler)
        hard.data('difficulty', _file.difficulty.hard)

        @selectFirst()

    back: ->
        @ui.initMenu(_sui.StartMenuMain)

    handler: =>
        file = new _file.File()
        file.fileState = new _file.fs.Chapter1()
        file.difficulty = @getSelected().data('difficulty')

        @ui.destroy()
        file.init()

class _cs.sui.StartMenu extends _cs.Menu
    
    f: ->
        @menuObj.getSelected().data('handler')()

    d: ->
        @menuObj.back()

class VisualNovel

    constructor: ->
        @wrapper = $('.vn-wrapper')
        @bgEl = @wrapper.find('.background')

    setBackgroundImage: (path) ->
        img = $('<img />').attr('src', path)
        @bgEl.html('').append(img)

    show: -> @wrapper.show()

    hide: -> @wrapper.hide()

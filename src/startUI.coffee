class window.StartUI

    constructor: ->
        @vn = new VisualNovel()
        @controlState = new _cs.ControlState(this)

    init: ->
        @vn.setBackgroundImage('images/start_background.png')
        @container = $('<div></div').addClass('start-menu-container')
        @container.appendTo(@vn.wrapper)

        newGame = $('<div></div>').addClass('menu-item')
        newGameMainText = $('<span>New game</span>').addClass('main-text')
        newGame.append(newGameMainText)

        @container.append(newGame)
        newGame.addClass('selected')

        @controlState = new _cs.Menu(this, @container)


class _cs.Menu extends _cs.ControlState

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


class _cs.StartUI extends _cs.Menu


class VisualNovel

    constructor: ->
        @wrapper = $('.vn-wrapper')
        @bgEl = @wrapper.find('.background')

    setBackgroundImage: (path) ->
        img = $('<img />').attr('src', path)
        @bgEl.html('').append(img)

    init: ->

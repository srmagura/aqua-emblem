window._cs = {}

class _cs.ControlState
    constructor: (@ui) ->
    up: ->
    down: ->
    left: ->
    right: ->
    f: ->
    d: ->
    s: ->
    e: ->
    v: ->

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

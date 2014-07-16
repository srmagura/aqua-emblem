class _sui.MenuMain extends _sui.Menu

    init: ->
        @menu.html('')

        @getMenuEl('New game').appendTo(@menu).
            data('handler', @handleNewGame)
        @selectFirst()
        @controlState = new _cs.sui.Menu(this, @menu)

    handleNewGame: =>
        @ui.initMenu(_sui.MenuDifficulty)


class _sui.MenuDifficulty extends _sui.Menu

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
        @ui.initMenu(_sui.MenuMain)

    handler: =>
        file = new _file.createNewFile(
            @getSelected().data('difficulty'))

        @ui.destroy()
        file.init()

class _sui.MenuNoData extends _sui.Menu

    init: ->
        @ui.messageDiv.text('Press F to continue').show()

        @getMenuEl('New game').appendTo(@menu).
            data('handler', @handleNewGame)
            
        @getMenuEl('Upload backup').appendTo(@menu).
            data('handler', @handleUpload)     
            
        @selectFirst()
        @controlState = new _cs.sui.Menu(this, @menu)

    handleNewGame: =>
        @ui.initMenu(_sui.MenuDifficulty)
        
    handleUpload: =>


class _sui.MenuDifficulty extends _sui.Menu

    init: ->
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
        
class _sui.MenuMain extends _sui.Menu

    init: ->    
        itemContinue = @getMenuEl('Continue',
            'Chapter 2: Marshmallows of Fate')
        itemContinue.appendTo(@menu).data('handler', @handleContinue)
        
        @getMenuEl('Save backup').appendTo(@menu).
            data('handler', @handleSaveBackup)
            
        @getMenuEl('Erase data').appendTo(@menu).
            data('handler', @handleErase)
            
        @selectFirst()
        @controlState = new _cs.sui.Menu(this, @menu)

    handleContinue: =>
        
    handleSaveBackup: =>
    
    handleErase: =>
        

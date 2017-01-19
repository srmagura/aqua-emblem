class _startui.MenuNoData extends _startui.Menu

    init: ->
        @ui.messageDiv.text('Press F to continue').show()

        @getMenuEl('New game').appendTo(@menu).
            data('handler', @handleNewGame)
            
        @getMenuEl('Upload backup').appendTo(@menu).
            data('handler', @handleUpload)
            
        @selectFirst()
        @controlState = new _cs.sui.Menu(this, @menu)

    handleNewGame: =>
        @ui.initMenu(_startui.MenuDifficulty)
        
    handleUpload: =>
        options = $.extend(@ui.dialogOptions, {
            buttons: [
                {
                    text: 'Upload',
                    click: @doUpload
                }
            ]
        })
      
        dia = @ui.uploadDialog
        dia.dialog(options)
        
        @ui.prevControlState = @ui.controlState
        @ui.controlState = new _cs.ControlState(@ui)
        
        dia.find('.error-div').hide()

        setTimeout((-> dia.find('textarea').val('')), 0)
        
    doUpload: =>
        invalid = false
        str = @ui.uploadDialog.find('textarea').val()
            
        unpickled = _file.File.unpickle(str)
        if unpickled is null
            invalid = true
            
        if invalid
            @ui.uploadDialog.find('.error').text(
                'Could not parse the save file.'
            )
            @ui.uploadDialog.find('.error-div').show()
        else
            @ui.uploadDialog.dialog('close')
            @ui.file = unpickled
            localStorage.setItem('file', @ui.file.pickle())
            @ui.initMenu(_startui.MenuMain)

class _startui.MenuDifficulty extends _startui.Menu

    init: ->
        normal = @getMenuEl('Normal',
            'The default difficulty.')
        normal.appendTo(@menu).data('handler', @handler)
        normal.data('difficulty', 'normal')

        hard = @getMenuEl('Hard',
            'How Aqua Emblem is meant to be played. ' +
            'Units start with lower stats ' +
            'and gain experience more slowly.')
        hard.appendTo(@menu).data('handler', @handler)
        hard.data('difficulty', 'hard')

        @selectFirst()

    back: ->
        @ui.initMenu(_startui.MenuNoData)

    handler: =>
        file = new _file.createNewFile(
            @getSelected().data('difficulty'))

        @ui.destroy()
        file.init()
        
class _startui.MenuMain extends _startui.Menu

    init: ->
        fs = @ui.file.fileState
        itemContinue = @getMenuEl('Continue',
            "Chapter #{fs.chapterId}: #{fs.chapterName}")
        itemContinue.appendTo(@menu).data('handler', @handleContinue)
        
        @getMenuEl('Save backup',
            'Clearing your browser data will delete your save. ' +
            'Save a backup to be safe.').
            appendTo(@menu).data('handler', @handleSaveBackup)
            
        @getMenuEl('Erase data',
            'If you want to start a new game or upload a backup.').
            appendTo(@menu).data('handler', @handleErase)
            
        @selectFirst()
        @controlState = new _cs.sui.Menu(this, @menu)

    handleContinue: =>
        @ui.destroy()
        @ui.file.init()
        
    handleSaveBackup: =>
        dia = @ui.saveBackupDialog
        dia.dialog(@ui.dialogOptions)
        
        str = @ui.file.pickle()
        dia.find('textarea').val(str)
        
        @ui.prevControlState = @ui.controlState
        @ui.controlState = new _cs.ControlState(@ui)
    
    handleErase: =>
        if confirm('Are you sure you want to delete your saved game?')
            @ui.file = null
            localStorage.removeItem('file')
            @ui.initMenu(_startui.MenuNoData)

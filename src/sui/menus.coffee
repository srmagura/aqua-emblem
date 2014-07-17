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

        setTimeout((-> dia.find('textarea').val('')), 0)
        
    doUpload: =>
        console.log 'doUpload'

class _sui.MenuDifficulty extends _sui.Menu

    init: ->
        normal = @getMenuEl('Normal',
            'The default difficulty.')
        normal.appendTo(@menu).data('handler', @handler)
        normal.data('difficulty', 'normal')

        hard = @getMenuEl('Hard',
            'How Aqua Emblem is meant to be played. ' +
            'Units start at a lower ' +
            'level and gain experience more slowly.')
        hard.appendTo(@menu).data('handler', @handler)
        hard.data('difficulty', 'hard')

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
        
    handleSaveBackup: =>  
        dia = @ui.saveBackupDialog
        dia.dialog(@ui.dialogOptions)
        
        str = JSON.stringify(@ui.file.pickle())
        dia.find('textarea').val(str)
        
        @ui.prevControlState = @ui.controlState
        @ui.controlState = new _cs.ControlState(@ui)
    
    handleErase: =>
        

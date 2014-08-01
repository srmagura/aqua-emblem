window.init = ->
    #return doChapter()
    
    ui = new _sui.StartUI()
    ui.init()
    
    
doChapter = ->
    #file = _file.File.unpickle(localStorage.getItem('file'))
    file = _file.createNewFile('normal')
    
    ui = new _cui.ChapterUI(file)
    ui.setChapter(_chapters.Chapter1)
    ui.startChapter((->), true)

window.init = ->
    #return doChapter()
    
    ui = new _sui.StartUI()
    ui.init()
    
    
doChapter = ->
    file = _file.File.unpickle(localStorage.getItem('file'))
    ui = new _cui.ChapterUI(file)
    ui.setChapter(_chapters.Chapter2)
    ui.startChapter((->), true)

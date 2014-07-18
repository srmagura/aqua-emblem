window.init = ->
    return doChapter()
    
    ui = new _sui.StartUI()
    ui.init()
    
    
doChapter = ->
    file = _file.createNewFile('hard')
    ui = new _cui.ChapterUI(file)
    ui.setChapter(_chapters.Chapter1)
    ui.startChapter((->), true)

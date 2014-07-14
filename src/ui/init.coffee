window.init = ->
    #ui = new _sui.StartUI()
    #ui.init()
    ui = new _cui.ChapterUI()
    ui.setChapter(_chapters.Chapter1)
    ui.startChapter((->), true)

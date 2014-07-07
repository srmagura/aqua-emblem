window.init = ->
    startUI = new _sui.StartUI()
    startUI.init()

initChapter = ->
    window.ui = new _cui.ChapterUI()

    chapter = new _chapters.Chapter1(ui)
    ui.setChapter(chapter)

    #chapter.doScrollSequence(ui.startChapter)
    ui.startChapter()


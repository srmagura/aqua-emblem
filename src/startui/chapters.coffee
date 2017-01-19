class _file.FileState

    constructor: (@file) ->

    chapterComplete: =>
        @ui.destroy()

        @file.setFileState(@nextFs)
        localStorage.setItem('file', @file.pickle())

        @ui = new _startui.StartUI(@file)
        @ui.init({message: @ui.messages.chapterComplete})

    @ui.chapterDisplay.init(@chapterId, @chapterIntro)


    chapter: =>
        @ui = new _chapterui.ChapterUI(@file)
        @ui.setChapter(_chapters.Chapter1)
        @ui.startChapter(@chapterComplete)

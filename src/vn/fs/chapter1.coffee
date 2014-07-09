class _file.fs.Chapter1 extends _file.FileState

    init: ->
        @ui = new _vn.VisualNovelUI()
        lines = [
            'Here is some text',
            'Here is the second line'
        ]
        @ui.fullTextbox.init(lines, @chapterDisplay)

    chapterDisplay: =>
        @ui.chapterDisplay.init('1', 'Hellhounds', @chapterIntro)

    chapterIntro: =>
        lines = [
            'So there was this guy named Ace',
            'He had a mercenary group'
        ]
        @ui.fullTextbox.init(lines, @chapter)

    chapter: =>
        @ui.destroy()
        @ui = new _cui.ChapterUI()
        @ui.setChapter(_chapters.Chapter1)
        @ui.startChapter()

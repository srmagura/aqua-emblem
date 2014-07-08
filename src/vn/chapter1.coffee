class _file.fs.Chapter1 extends _file.FileState

    init: ->
        @ui = new _vn.VisualNovelUI()
        lines = [
            'Here is some text',
            'Here is the second line'
        ]
        @ui.fullTextbox.init(lines, @doChapter)

    doChapter: ->
        @ui.destroy()
        @ui = new _cui.ChapterUI()
        @ui.setChapter(new _chapters.Chapter1(ui))
        @ui.startChapter()

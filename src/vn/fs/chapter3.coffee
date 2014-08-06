class _file.fs.Chapter3 extends _file.FileState

    constructor: (@file) ->
        super(@file)
        @chapterId = 3
        @chapterName = 'Audition'
    
        @nextFs = _file.fs.Chapter4
    
    
    init:  =>
        @ui = new _vn.VisualNovelUI()
        lines = [

        ]

        @ui.scene.init(lines, 'hellhounds_hq', @chapterDisplay)

    chapterDisplay: =>
        @ui.chapterDisplay.init(@chapterId, @chapterName, @destroyVn)
        
    destroyVn: =>
        @ui.destroy(@chapter)

    chapter: =>
        @ui = new _cui.ChapterUI(@file)
        @ui.setChapter(_chapters.Chapter3)
        @ui.startChapter(@endScene)

    endScene: =>
        lines = [
            ['luciana', 'We did it... I can hardly believe it.'],
            ['ace', 'Yeah. The girl\'s over here. It looks likes she\'s still out of it. We\'ll take her with us.'],
            ['shiina', '... ungh ..... who are you?'],
            ['ace', 'I\'m Ace. You\'re safe now.'] 
        ]       

        @ui.scene.init(lines, 'forest', @chapterComplete)

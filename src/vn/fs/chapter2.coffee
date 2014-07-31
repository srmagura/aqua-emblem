class _file.fs.Chapter2 extends _file.FileState

    constructor: (@file) ->
        super(@file)
        @chapterId = 2
        @chapterName = 'The red string of fate'
    
        @nextFs = _file.fs.Chapter2
    
    
    init:  =>
        @ui = new _vn.VisualNovelUI()
        lines = [
            ['arrow', 'Stop. Do you hear that?'],
            ['luciana', 'Shhh. Hide here. There\'s a group of armed men coming.'],
            ['ace', 'More bandits? I thought we dealt with all of them.'],
            ['luciana', 'No... these aren\'t the small-time thieves that have been attacking Yaksasu village. They\'re professionals.'],
            ['ace', 'Damn... Best to stay here and let them pass.'],
            ['arrow', 'Do you see that? One of them is carrying a girl!'],
            ['ace', 'She\'s unconscious. We have to help her!'],
            ['kenji', 'Judging by her clothes, she looks like nobility! This one is gonna pay well... ;)'],
            ['ace', 'Shut up Kenji, there\'s no time for that.'],
            ['ace', 'HEY! What are you doing with that girl?'],
            ['morgan', 'It\'s none of your business, punk. Move it.'],
            ['ace', 'No. We won\'t let you pass!']
        ]

        @ui.scene.init(lines, 'forest', @chapterDisplay)

    chapterDisplay: =>
        @ui.chapterDisplay.init(@chapterId, @chapterName, @destroyVn)
        
    destroyVn: =>
        @ui.destroy(@chapter)

    chapter: =>
        @ui = new _cui.ChapterUI(@file)
        @ui.setChapter(_chapters.Chapter2)
        @ui.startChapter(@deathScene)
     
    deathScene: =>
        @ui = new _vn.VisualNovelUI()

        lines = [
            ['morgan', 'Kah... to think that I could lose to a group of nobodies like you guys... this was supposed to be an easy job......']
        ]
        
        @ui.scene.init(lines, 'forest', @victoryScene)

    victoryScene: =>
        lines = [
            ['luciana', 'We did it... I can hardly believe it.'],
            ['ace', 'Yeah. The girl\'s over here. It looks likes she\'s still out of it. We\'ll take her with us.'],
            ['shiina', '... ungh ..... who are you?'],
            ['ace', 'I\'m Ace. You\'re safe now.'] 
        ]       

        @ui.scene.init(lines, 'forest', @chapterComplete)

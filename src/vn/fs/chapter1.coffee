class _file.fs.Chapter1 extends _file.FileState

    init: ->
        return @scene2()
        
        @ui = new _vn.VisualNovelUI()
        lines = [
            [
                'Eutruria was a large, peaceful kingdom. The Hadoka family had ruled since times long forgotten, maintaining order throughout the land.',
                'The current king, Hitoyoshi, was benevolent and had rightfully earned the respect of his people. But as King Hitoyoshi’s health declined, a change in leadership was inevitable.',
                'Legend has it that the Hadoka family heirloom, the Aqua Emblem, would recognize the true heir to the throne when the issue of succession arose.'
            ],
            [
                'But the Hadokas viewed this legend for what it was: a legend. To them, the Aqua Emblem was just a blue gemstone. Its influence was purely symbolic.',
                'When King Hitoyoshi died, his son Sanzu ascended to the throne. And that was when the Aqua Emblem made its decision...'
            ]
        ]
        @ui.fullTextbox.init(lines, @chapterDisplay)


    chapterId: 1
    chapterName: 'Hellhounds'

    chapterDisplay: =>
        @ui.chapterDisplay.init(@chapterId, @chapterName, @chapterIntro)

    chapterIntro: =>
        lines = [
            [
                'In the forests far to the west of the Eutrurian capital, the mercenary group "Hellhounds" made its base.',
                'The Hellhounds took on any work they could find. If the money was good, they fought without hesitation.',
                'But their leader, Ace, dreamed of a higher purpose...'
            ]
        ]
        @ui.fullTextbox.init(lines, @scene1)

    scene1: =>

        lines = [
            ['ace', 'Listen up everybody, we have a job today.'],
            ['arrow', 'Finally something to do!'],
            ['ace', 'Bandits have been raiding Yaksasu village, and the villagers will pay us if we drive them out.'],
            ['luciana', 'I\'ve heard about this. They have a fort on Yaksasu ridge. Sneaking up on them will be nearly impossible...'],
            ['ace', 'Exactly. Arrow, Kenji: be careful on this one. I know it’s been a long time since Hitomi died, but... I can’t let that happen again.'],
            ['arrow', 'We hear you, Ace. Don\'t worry. We\'re stronger than we were back then.'],
            ['luciana', 'Yeah, Arrow\'s right.'],
            ['ace', 'Kenji, anything to add?'],
            ['kenji', 'Huh? What are we talking about? But yes! That\'s a great idea, boss!'],
            ['ace', 'Uh... I didn\'t suggest anything.'],
            ['kenji', 'Okay, fine, whatever. Let\'s go out to play with those bandits! It’ll be fun!! =D'],
            ['ace', 'And you wonder why I worry about your safety... -.-'],
            ['arrow', 'Anyway, shouldn\'t we be heading out?'],
            ['luciana', 'Yeah. Let\'s go.']
        ]

        @ui.scene.locationText = 'Hellhounds HQ'
        @ui.scene.init(lines, 'hellhounds_hq', @destroyVn)

    destroyVn: =>
        @ui.destroy(@chapter)

    chapter: =>
        @ui = new _cui.ChapterUI(@file)
        @ui.setChapter(_chapters.Chapter1)
        @ui.startChapter(@scene2)
     
    scene2: =>
        @ui = new _vn.VisualNovelUI()

        lines = [
            ['luciana', 'Now that wasn\'t too hard, was it?'],
            ['arrow', 'Yeah! We showed them!'],
            ['kenji', 'w00t!'],
            ['ace', 'Yeah, I\'m glad we\'re okay. Personally, I\'m exhausted, so let\'s return to HQ.']
        ]

        @ui.scene.init(lines, 'forest', @chapterComplete)

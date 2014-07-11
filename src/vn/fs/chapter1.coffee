class _file.fs.Chapter1 extends _file.FileState

    init: ->
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

    chapterDisplay: =>
        @ui.chapterDisplay.init('1', 'Hellhounds', @chapterIntro)

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
        bgImage = 'hellhounds_hq.png'

        ace = new _uclass.special.Ace()
        arrow = new _uclass.special.Arrow()
        luciana = new _uclass.special.Luciana()
        kenji = new _uclass.special.Kenji()

        lines = [
            [ace, 'Hello everybody Hello everybody Hello everybody Hello everybody Hello everybody Hello everybody Hello everybody '],
            [arrow, 'The second line']
        ]

        @ui.scene.init(lines, bgImage, @chapter)

    chapter: =>
        @ui.destroy()
        @ui = new _cui.ChapterUI()
        @ui.setChapter(_chapters.Chapter1)
        @ui.startChapter()

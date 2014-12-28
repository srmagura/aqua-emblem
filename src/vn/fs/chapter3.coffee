class _file.fs.Chapter3 extends _file.FileState

    constructor: (@file) ->
        super(@file)
        @chapterId = 3
        @chapterName = 'Audition'
    
        @nextFs = _file.fs.Chapter3
    
    
    init:  =>
        return @endScene()
        @ui = new _vn.VisualNovelUI()
        lines = [
            ['ace', 'So... who are you? And what happened?'],
            ['shiina', 'I\'m ... Shiina. I was minding my own business... and... I don\'t really know what happened, but those men must have knocked me out and kidnapped me.'],
            ['luciana', 'Mmm... I\'m sorry that happened.'],
            ['ace', 'Where were you when they attacked you?'],
            ['shiina', 'I was on a side street, near the Heibon district plaza.'],
            ['ace', 'Plaza? Heibon? Luciana, do you know what she\'s talking about?'],
            ['luciana', 'No idea. Shiina, what\'s the closest town to where you live?'],
            ['shiina', 'The closest town? I live in the Capitol, duh.'],
            ['ace', 'THE CAPITOL?'],
            ['shiina', 'Yeah, aren\'t we just outside the city walls?'],
            ['ace', 'No!'],
            ['luciana', 'The Capitol is on the other side of the country! We\'re in the western forests right now!'],
            ['shiina', 'WHAT??'],
            ['ace', 'Wow... the men who abducted you carried you all the way across Eutruria.'],
            ['luciana', 'There\'s nothing ordinary about that. This is getting suspicious...'],
            ['ace', 'Yeah. Shiina, do you have any idea why someone would want to abduct you?'],
            ['shiina', 'I mean... uh... they probably wanted money, I guess? Or maybe they mistook me for someone else?'],
            ['luciana', 'I guess that\'s possible.'],
            ['ace', 'Seems kinda farfetched to me... -.-'],
            ['ace', 'Anyway, you can\'t stay with us forever.'],
            ['luciana', 'Sorry to be rude, but he\'s right. What do you plan to do? We can escort you to the closest town if you want.'],
            ['shiina', 'Umm... I think I want to join you!'],
            ['ace', 'What the ...? You know we\'re a mercenary group, right? Like we fight for a living?'],
            ['shiina', 'I know. I can fight too. I\'ve been practicing holy magic since I was a child!'],
            ['shiina', '(I probably shouldn\'t tell them that I\'ve never used my magic for fighting.)'],
            ['ace', 'Really? You don\'t look like you could survive a single hit.'],
            ['luciana', 'Come on Ace, why don\'t we give her a chance?'],
            ['ace', '... urgh. Fine. You can come with us on ONE mission.'],
            ['shiina', 'Yay! So it\'s like an audition, right?'],
            ['ace', 'Err, something like that. I\'ll try to protect you, but... it\'s not my fault if you die.']
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
        @ui = new _vn.VisualNovelUI()
    
        lines = [
            ['ace', 'Well that wasn\'t the best fighting I\'ve ever seen, but at least you\'re still alive.'],
            ['shiina', 'Eh, thank you?'],
            ['luciana', 'Oh come on Ace, lighten up. You did well Shiina.'],
            ['arrow', 'Your magic was like sooooo cool Shiina! You were amazing!'],
            ['ace', '(Shut up Arrow, you just think she\'s cute...)'],
            ['shiina', 'Thanks Luciana! Thanks Arrow! Does this mean I can join the Hellhounds now?'],
            ['ace', 'No... but I\'ll think about letting you fight with us again. So you can stay with us for now.'],
            ['kenji', 'Thank you for playing Aqua Emblem! I\'m sorry that it isn\'t a complete game!']
        ]

        @ui.scene.init(lines, 'forest', @chapterComplete)

class UI

    tw: 35

    constructor: ->
        @then = Date.now()
        @canvas = $('canvas')
        @ctx = @canvas[0].getContext('2d')

    setChapter: (@chapter) ->
        @canvas.attr('width', @chapter.map.width*@tw)
        @canvas.attr('height', @chapter.map.height*@tw)
        $('.wrapper').css('width', @canvas.width() +
            $('.left-sidebar').width()*2 + 30)
        $('.game-wrapper').css('height', @canvas.height() + 40)
        $('.victory-condition').text(@chapter.victoryCondition.text)

    mainLoop: ->
        now = Date.now()
        delta = now - @then

        requestAnimationFrame(->)

        if @chapter?
            @chapter.render(this, @ctx)


window.init = ->
    ui = new UI()
    chapter = new Chapter1(ui)
    ui.setChapter chapter
    ui.mainLoop()

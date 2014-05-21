class UI

    tw: 35

    constructor: ->
        @then = Date.now()
        @canvas = $('canvas')
        @ctx = @canvas[0].getContext('2d')
        @cursor = new Cursor()

        @controlState = new CsMap(this)
        $(window).keydown(@keydownHandler)

    setChapter: (@chapter) ->
        @canvas.attr('width', @chapter.map.width*@tw)
        @canvas.attr('height', @chapter.map.height*@tw)
        $('.wrapper').css('width', @canvas.width() +
            $('.left-sidebar').width()*2 + 30)
        $('.game-wrapper').css('height', @canvas.height() + 40)
        $('.victory-condition').text(@chapter.victoryCondition.text)

    render: ->
        if @chapter?
            @chapter.render(this, @ctx)

        @cursor.render(this, @ctx)


    keydownHandler: (e) =>
        #console.log(e.which)
        switch e.which
            when 38 then @controlState.up()
            when 40 then @controlState.down()
            when 37 then @controlState.left()
            when 39 then @controlState.right()
            when 70 then @controlState.f()
            when 68 then @controlState.d()
            when 83 then @controlState.s()

        if 37 <= e.which <= 40
            e.preventDefault()
            return false

    mainLoop: =>
        now = Date.now()
        delta = now - @then
        @then = now

        requestAnimationFrame(@mainLoop)
        @render()


window.init = ->
    ui = new UI()
    chapter = new Chapter1(ui)
    ui.setChapter chapter
    ui.mainLoop()

class Cursor

    constructor: ->
        @visible = true
        @pos = new Position(0, 0)

    moveTo: (pos) ->
        @pos = pos.clone()

    move: (di, dj) ->
        @moveTo(@pos.add(new Position(di, dj)))

    render: (ui, ctx) ->
        return if not @visible

        s = 5
        tw = ui.tw

        ctx.strokeStyle = 'purple'
        ctx.beginPath()
        ctx.rect(@pos.j*tw + s, @pos.i*tw + s, tw - 2*s, tw - 2*s)
        ctx.stroke()

class window.ControlState
    constructor: (@ui) ->
    up: ->
    down: ->
    left: ->
    right: ->
    f: ->
    d: ->
    s: ->


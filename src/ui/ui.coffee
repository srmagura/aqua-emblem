MOVEMENT_SPEED = .4

class UI

    tw: 35

    constructor: ->
        @then = Date.now()
        @canvas = $('canvas')
        @ctx = @canvas[0].getContext('2d')
        @cursor = new Cursor(this)

        @controlState = new CsMap(this)
        $(window).keydown(@keydownHandler)

        @unitInfoBox = new UnitInfoBox(this, '.sidebar .unit-info')
        @unitInfoWindow = new UnitInfoWindow(this)
        @actionMenu = new ActionMenu(this)
        @weaponMenu = new WeaponMenu(this)
        @battleStatsPanel = new BattleStatsPanel(this)
        @messageBox = new MessageBox(this)

    setChapter: (@chapter) ->
        $('.wrapper').css('width', @canvas.width() +
            $('.left-sidebar').width()*2 + 30)
        $('.game-wrapper').css('height', @canvas.height() + 40)
        $('.victory-condition').text(@chapter.victoryCondition.text)
        @cursor.moveTo(new Position(0, 0))
        @chapter.initTurn(@chapter.playerTeam)

    loadAllImages: ->
        div = $('.invisible-images')
        for path in ALL_IMAGE_PATHS
            img = $("<img src='#{path}' />")
            div.append(img)

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

    update: (delta) ->
        for unit in @chapter.units
            if unit.direction?
                if Math.abs(unit.offset.i) >= @tw or
                Math.abs(unit.offset.j) >= @tw
                    unit.pathNext()
                else
                    unit.offset = unit.offset.add(
                        unit.direction.scale(delta * MOVEMENT_SPEED))

    mainLoop: =>
        now = Date.now()
        delta = now - @then
        @then = now

        @update(delta)
        requestAnimationFrame(@mainLoop)
        @render()

window.init = ->
    window.ui = new UI()
    ui.loadAllImages()

    chapter = new Chapter1(ui)
    ui.setChapter chapter
    ui.mainLoop()

class Cursor

    constructor: (@ui) ->
        @visible = true

    moveTo: (pos) ->
        @pos = pos.clone()
        @ui.chapter.playerTurn.updateDestination()

        unitAt = @ui.chapter.getUnitAt(@pos)
        if unitAt is null
            @ui.unitInfoBox.hide()
        else
            @ui.unitInfoBox.populate(unitAt)
            @ui.unitInfoBox.show()

    move: (di, dj) ->
        @moveTo(@pos.add(new Position(di, dj)))

    render: (ui, ctx) ->
        return if not @visible or not @pos?

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

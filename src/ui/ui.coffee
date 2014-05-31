class UI

    tw: 35

    constructor: ->
        @then = Date.now()
        @canvas = $('canvas')
        @ctx = @canvas[0].getContext('2d')

        @origin = new Position(0, 0)
        @cursor = new Cursor(this)

        @controlState = new CsMap(this)
        $(window).keydown(@keydownHandler)

        @unitInfoBox = new UnitInfoBox(this, '.sidebar .unit-info')
        @unitInfoWindow = new UnitInfoWindow(this)
        @actionMenu = new ActionMenu(this)
        @weaponMenu = new WeaponMenu(this)
        @battleStatsPanel = new BattleStatsPanel(this)
        @messageBox = new MessageBox(this)

        @centerOffset = new Position(@canvas.height()/2,
            @canvas.width()/2)

    setChapter: (@chapter) ->
        $('.wrapper').css('width', @canvas.width() +
            $('.left-sidebar').width()*2 + 30)
        $('.game-wrapper').css('height', @canvas.height() + 40)
        $('.victory-condition').text(@chapter.victoryCondition.text)
        @cursor.moveTo(new Position(0, 0))
        @chapter.initTurn(@chapter.playerTeam)

    setCenter: (pos) ->
        @origin = pos.subtract(@centerOffset)

    getCenter: ->
        return @origin.add(@centerOffset)

    scrollTo: (@scrollDest, @scrollCallback) ->
        center = @getCenter()
        @direction = @scrollDest.scale(@tw).
        subtract(center).toUnitVector()
        @scrollSpeed = .2

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
        if @direction?
            @origin = @origin.add(
                @direction.scale(delta*@scrollSpeed))
            alt = @scrollDest.scale(@tw).subtract(@getCenter())

            if alt.dot(@direction) <= 0
                @setCenter(@scrollDest.scale(@tw))
                @direction = null
                @scrollCallback()

        for unit in @chapter.units
            if unit.direction?
                if unit.followingPath and
                (Math.abs(unit.offset.i) >= @tw or
                Math.abs(unit.offset.j) >= @tw)
                    unit.pathNext()
                else
                    unit.offset = unit.offset.add(
                        unit.direction.scale(
                            delta * unit.movementSpeed))

    mainLoop: =>
        now = Date.now()
        delta = now - @then
        @then = now

        @update(delta)
        requestAnimationFrame(@mainLoop)
        @render()

window.init = ->
    window.ui = new UI()

    chapter = new ChapterTestHuge(ui)
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
        newPos = @pos.add(new Position(di, dj))
        newPosPx = newPos.scale(@ui.tw)

        c = @ui.canvas
        if newPosPx.j >= c.width() + @ui.origin.j or
        newPosPx.j < @ui.origin.j
            @ui.origin.j += dj*@ui.tw

        if newPosPx.i >= c.height() + @ui.origin.i or
        newPosPx.i < @ui.origin.i
            @ui.origin.i += di*@ui.tw

        @moveTo(newPos)

    render: (ui, ctx) ->
        return if not @visible or not @pos?

        s = 5
        tw = ui.tw

        ctx.strokeStyle = 'purple'
        ctx.beginPath()
        ctx.rect(@pos.j*tw + s - ui.origin.j,
        @pos.i*tw + s - ui.origin.i,
        tw - 2*s, tw - 2*s)
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

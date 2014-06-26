class UI

    tw: 35

    constructor: ->
        @then = Date.now()
        @canvas = $('canvas')
        @ctx = @canvas[0].getContext('2d')
        @canvasDim = new Position(@canvas.height()/@tw,
            @canvas.width()/@tw)

        @origin = new Position(0, 0)
        @cursor = new Cursor(this)

        @controlState = new CsMap(this)
        $(window).keydown(@keydownHandler)

        @actionMenu = new ActionMenu(this)
        @weaponMenu = new WeaponMenu(this)
        @battleStatsPanel = new BattleStatsPanel(this)
        @expBar = new ExpBar(this)

        skillInfoBoxEl = $('.sidebar .skill-info-box')
        skillInfoBoxEl.clone().appendTo($('.canvas-container'))
        @skillInfoBox = new SkillInfoBox(this, skillInfoBoxEl)

        skillsBoxEl = $('.sidebar .skills-box')
        skillsBoxEl.addClass('neutral-box')
        @skillsBox = new SkillsBox(this, skillsBoxEl, @skillInfoBox)

        @unitInfoBox = new UnitInfoBox(this, '.sidebar .unit-info')
        @unitInfoWindow = new UnitInfoWindow(this)
        @levelUpWindow = new LevelUpWindow(this)
        @tradeWindow = new TradeWindow(this)

        @canvasOverlay = new CanvasOverlay(this)
        @viewportOverlay = new ViewportOverlay(this)

        @messageBox = new MessageBox(this)
        @endTurnMenu = new EndTurnMenu(this)

        @staticTurn = new Turn(this)

    centerElement: (el, padding) ->
        css = {}
        css.top = (@canvas.height()-el.height())/2 - padding
        css.left = (@canvas.width()-el.width())/2 - padding
        return css

    setChapter: (@chapter) ->
        $('.wrapper').css('width', @canvas.width() +
            $('.left-sidebar').width()*2 + 30)
        $('.game-wrapper').css('height', @canvas.height() + 40)
        $('.victory-condition').text(@chapter.victoryCondition.text)

        @terrainBox = new TerrainBox(this)
        @cursor.moveTo(new Position(0, 0))

        @chapter.initTurn(@chapter.playerTeam)

    onScreen: (pos) ->
        delta = pos.scale(@tw).subtract(@origin)
        return 0 <= delta.i < @canvas.height() and
        0 <= delta.j < @canvas.width()

    scrollTo: (pos, @scrollCallback) ->
        centerOffset = new Position(5, 6)
        @scrollDest = pos.subtract(centerOffset)

        map = @chapter.map

        maxI = map.height - @canvasDim.i
        if @scrollDest.i < 0
            @scrollDest.i = 0
        else if @scrollDest.i > maxI
            @scrollDest.i = maxI

        maxJ = map.width - @canvasDim.j
        if @scrollDest.j < 0
            @scrollDest.j = 0
        else if @scrollDest.j > maxJ
            @scrollDest.j = maxJ

        @direction = @scrollDest.scale(@tw).
        subtract(@origin)
            
        if not @direction.equals(new Position(0, 0))
            @direction = @direction.toUnitVector()
            @scrollSpeed = .2
        else
            @direction = null

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
            when 69 then @controlState.e()

        if 37 <= e.which <= 40
            e.preventDefault()
            return false

    update: (delta) ->
        if @direction?
            @origin = @origin.add(
                @direction.scale(delta*@scrollSpeed))

            alt = @scrollDest.scale(@tw).subtract(@origin)

            if alt.dot(@direction) <= 0
                @origin = @scrollDest.scale(@tw)
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

    chapter = new Chapter1(ui)
    ui.setChapter chapter
    ui.mainLoop()

class Cursor

    constructor: (@ui) ->
        @visible = true

    moveTo: (pos) ->
        #console.log(pos)
        @pos = pos.clone()
        @ui.controlState.moved()
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
    e: ->
    moved: ->

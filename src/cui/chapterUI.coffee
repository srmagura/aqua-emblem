window._cui = {}

class _cui.ChapterUI

    tw: 35

    constructor: ->
        @expMultiplier = 1
        @speedMultiplier = 1

        @then = Date.now()
        @canvas = $('canvas')
        @ctx = @canvas[0].getContext('2d')
        @canvasDim = new Position(@canvas.height()/@tw,
            @canvas.width()/@tw)

        @origin = new Position(0, 0)
        @cursor = new _cui.Cursor(this)

        @controlState = new _cs.Chapter(this)
        $(window).keydown(@keydownHandler)

        @actionMenu = new _cui.ActionMenu(this)
        @weaponMenu = new _cui.WeaponMenu(this)
        @battleStatsPanel = new _cui.BattleStatsPanel(this)
        @expBar = new _cui.ExpBar(this)

        skillInfoBoxEl = $('.sidebar .skill-info-box')
        skillInfoBoxEl.clone().appendTo($('.canvas-container'))
        @skillInfoBox = new _cui.SkillInfoBox(this, skillInfoBoxEl)

        skillsBoxEl = $('.sidebar .skills-box')
        skillsBoxEl.addClass('neutral-box')
        @skillsBox = new _cui.SkillsBox(this, skillsBoxEl, @skillInfoBox)

        @unitInfoBox = new _cui.UnitInfoBox(this, '.sidebar .unit-info')
        @unitInfoWindow = new _cui.UnitInfoWindow(this)
        @levelUpWindow = new _cui.LevelUpWindow(this)
        @tradeWindow = new _cui.TradeWindow(this)

        @canvasOverlay = new _cui.CanvasOverlay(this)
        @viewportOverlay = new _cui.ViewportOverlay(this)

        @messageBox = new _cui.MessageBox(this)
        @endTurnMenu = new _cui.EndTurnMenu(this)

        @terrainBox = new _cui.TerrainBox(this)
        @speedMultiplierBox = $('.speed-multiplier-box')

        @staticTurn = new _turn.Turn(this)

    centerElement: (el, padding) ->
        css = {}
        css.top = (@canvas.height()-el.height())/2 - padding
        css.left = (@canvas.width()-el.width())/2 - padding
        return css

    setChapter: (@chapter) ->
        @mainLoop()
        $('.victory-condition').text(@chapter.victoryCondition.text)

    startChapter: ->
        @chapter.initTurn(@chapter.playerTeam)

    onScreen: (pos) ->
        delta = pos.scale(@tw).subtract(@origin)
        return 0 <= delta.i < @canvas.height() and
        0 <= delta.j < @canvas.width()

    scrollTo: (pos, @scrollCallback, @scrollSpeed=null) ->
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
            if not @scrollSpeed?
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
            when 86 then @controlState.v()
            
        prevent = [37, 38, 39, 40]
        if e.which in prevent
            e.preventDefault()
            return false

    update: (delta) ->
        delta *= @speedMultiplier

        if @direction?
            @origin = @origin.add(
                @direction.scale(delta*@scrollSpeed))

            alt = @scrollDest.scale(@tw).subtract(@origin)

            if alt.dot(@direction) <= 0
                @origin = @scrollDest.scale(@tw)
                @direction = null

                if @scrollCallback?
                    @scrollCallback()

        for unit in @chapter.units
            unit.updateLunge()
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


class _cs.Chapter extends _cs.ControlState
    constructor: (@ui) ->
    up: ->
    down: ->
    left: ->
    right: ->
    f: ->
    d: ->
    s: ->
    e: ->
    v: =>
        if @ui.speedMultiplier == 3
            @ui.speedMultiplier = 1
            @ui.speedMultiplierBox.hide()
        else
            @ui.speedMultiplier = 3
            @ui.speedMultiplierBox.show()

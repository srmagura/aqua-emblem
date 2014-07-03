window.init = ->
    window.ui = new ChapterUI()

    chapter = new Chapter1(ui)
    ui.setChapter(chapter)
    ui.startChapter()

class ChapterUI

    tw: 35

    constructor: ->
        window.SPEED_MULTIPLIER = 1
        @then = Date.now()
        @canvas = $('canvas')
        @ctx = @canvas[0].getContext('2d')
        @canvasDim = new Position(@canvas.height()/@tw,
            @canvas.width()/@tw)

        @origin = new Position(0, 0)
        @cursor = new Cursor(this)

        @controlState = new _cs.Map(this)
        $(window).keydown(@keydownHandler)
        $(window).keyup(@keyupHandler)

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

        @terrainBox = new TerrainBox(this)
        @speedMultiplierBox = $('.speed-multiplier-box')

        @staticTurn = new Turn(this)

    centerElement: (el, padding) ->
        css = {}
        css.top = (@canvas.height()-el.height())/2 - padding
        css.left = (@canvas.width()-el.width())/2 - padding
        return css

    setChapter: (@chapter) ->
        @mainLoop()

        $('.victory-condition').text(@chapter.victoryCondition.text)
        @cursor.moveTo(new Position(0, 0))

    startChapter: ->
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
            when 32 then @controlState.space()
            
        prevent = [32, 37, 38, 39, 40]
        if e.which in prevent
            e.preventDefault()
            return false

    keyupHandler: (e) =>
        switch e.which
            when 32 then @controlState.spaceUp()

    update: (delta) ->
        delta *= SPEED_MULTIPLIER

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


window._cs = {}
class _cs.ControlState
    constructor: (@ui) ->
    up: ->
    down: ->
    left: ->
    right: ->
    f: ->
    d: ->
    s: ->
    e: ->
    space: ->
    spaceUp: ->
    moved: ->

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
    space: ->
        window.SPEED_MULTIPLIER = 3
        @ui.speedMultiplierBox.show()
    spaceUp: ->
        window.SPEED_MULTIPLIER = 1
        @ui.speedMultiplierBox.hide()
    moved: ->

window._cui = {}
_cs.cui = {}

class _cui.ChapterUI extends UI

    tw: 35

    constructor: ->
        super()

        @speedMultiplier = 1
        @fadeDelay = 1000
        @gameWrapper = $('.game-wrapper')

        @then = Date.now()
        @canvas = $('canvas')
        @ctx = @canvas[0].getContext('2d')
        @canvasDim = new Position(@canvas.height()/@tw,
            @canvas.width()/@tw)

        @cursor = new _cui.Cursor(this)

        @controlState = new _cs.cui.Chapter(this)

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
        @speedMultiplierBox = $('.speed-multiplier-box').hide()

        @staticTurn = new _turn.Turn(this)

    setChapter: (chapterCls) ->
        if not @file?
            console.log 'ChapterUI: file not set'
            @file = new _file.File()
            @file.difficulty = _file.difficulty.hard
        
        @expMultiplier = @file.difficulty.expMultiplier

        @chapter = new chapterCls(this)
        $('.victory-condition').text(@chapter.victoryCondition.text).
            show()

        @origin = @chapter.origin0
        @mainLoop()

    startChapter: (@callback, devMode=false) ->
        afterFade = =>
            @chapter.doScrollSequence(afterScroll)

        afterScroll = =>
            @chapter.initTurn(@chapter.playerTeam)

        if not devMode
            @gameWrapper.fadeIn(@fadeDelay, afterFade)
        else
            @gameWrapper.show()
            @origin = new Position(0,0)
            afterScroll()

    doneVictory: =>
        @destroy(@callback)

    doneDefeat: =>
        callback = =>
            ui = new _sui.StartUI()
            ui.init(true)

        @destroy(callback)

    destroy: (callback) ->
        @gameWrapper.fadeOut(@fadeDelay, callback)

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

    centerElement: (el, padding) ->
        css = {}
        css.top = (@canvas.height()-el.height())/2 - padding
        css.left = (@canvas.width()-el.width())/2 - padding
        return css

    render: ->
        if @chapter?
            @chapter.render(this, @ctx)

        @cursor.render(this, @ctx)

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


class _cs.cui.Chapter extends _cs.ControlState
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

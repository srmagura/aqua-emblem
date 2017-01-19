window._chapterui = {}
_cs.cui = {}

class _chapterui.ChapterUI extends UI

    tw: 35

    constructor: (@file) ->
        super()
        
        @setConfirmUnload(true)

        @expMultiplier = @file.difficulty.expMultiplier
        @speedMultiplier = 1
        
        @fadeDelay = 1000
        @gameWrapper = $('.game-wrapper')

        @then = Date.now()
        @canvas = $('canvas')
        @ctx = @canvas[0].getContext('2d')
        @canvasDim = new Position(10, 12)

        @cursor = new _chapterui.Cursor(this)

        @controlState = new _cs.cui.Chapter(this)

        @actionMenu = new _chapterui.ActionMenuMain(this)
        @weaponMenu = new _chapterui.WeaponMenu(this)
        @itemMenu = new _chapterui.ItemMenu(this)
        
        @battleStatsPanel = new _chapterui.BattleStatsPanel(this)
        @expBar = new _chapterui.ExpBar(this)

        skillInfoBoxEl = $('.sidebar .skill-info-box')
        skillInfoBoxEl.clone().appendTo($('.canvas-container'))
        @skillInfoBox = new _chapterui.SkillInfoBox(this, skillInfoBoxEl)

        skillsBoxEl = $('.sidebar .skills-box')
        skillsBoxEl.addClass('neutral-box')
        @skillsBox = new _chapterui.SkillsBox(this, skillsBoxEl, @skillInfoBox)

        @unitInfoBox = new _chapterui.UnitInfoBox(this, '.sidebar .unit-info')
        @unitInfoWindow = new _chapterui.UnitInfoWindow(this)
        @levelUpWindow = new _chapterui.LevelUpWindow(this)
        @tradeWindow = new _chapterui.TradeWindow(this)

        @canvasOverlay = new _chapterui.CanvasOverlay(this)
        @viewportOverlay = new _chapterui.ViewportOverlay(this)

        @messageBox = new _chapterui.MessageBox(this)
        @endTurnMenu = new _chapterui.EndTurnMenu(this)

        @terrainBox = new _chapterui.TerrainBox(this)
        @speedMultiplierBox = $('.speed-multiplier-box').hide()

        @staticTurn = new _turn.Turn(this)

    setChapter: (chapterCls) ->
        @chapter = new chapterCls(this)
        @chapter.setPlayerTeam(@file.playerTeam)
        
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
            ui = new _startui.StartUI()
            ui.init({fade: true})

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

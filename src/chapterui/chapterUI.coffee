window._chapterui = {}
_cs.chapterui = {}

class _chapterui.ChapterUI extends UI
    # The user interface while the player is playing a chapter

    # Tile width in pixels
    tw: 35

    constructor: (@file) ->
        # Setup everything we will need.
        # In particular, create CoffeeScript variables for all of the
        # HTML elements we the UI controls

        super()

        # User is prompted with a dialog before being allowed to leave
        # the page
        @setConfirmUnload(true)

        @expMultiplier = 1.33
        @speedMultiplier = 1

        @fadeDelay = 1000
        @gameWrapper = $('.game-wrapper')

        @then = Date.now()
        @canvas = $('canvas')
        @ctx = @canvas[0].getContext('2d')
        @canvasDim = new Position(10, 12)

        @cursor = new _chapterui.Cursor(this)

        @controlState = new _cs.chapterui.Chapter(this)

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
        # Begin the chapter
        # callback - function to call after victory
        # devMode - if true, disables initial scrolling
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
        # Called after chapter ends in victory
        # Fade out then restart the game
        @destroy(init)

    doneDefeat: =>
        # Called after chapter ends in defeat
        # Fade out then restart the game
        @destroy(init)

    destroy: (callback) ->
        # When done with the chapter, fade out
        @gameWrapper.fadeOut(@fadeDelay, callback)

    onScreen: (pos) ->
        # Return true if pos is shown through the current viewport
        # return false if it's not visible
        delta = pos.scale(@tw).subtract(@origin)
        return 0 <= delta.i < @canvas.height() and
        0 <= delta.j < @canvas.width()

    scrollTo: (pos, @scrollCallback, @scrollSpeed=null) ->
        # Gradually scroll the viewport to so that `pos` is displayed
        # in the center

        # Define what we mean by 'center'
        centerOffset = new Position(5, 6)

        # The tile that should be in the top-left corner when we are
        # done scrolling
        @scrollDest = pos.subtract(centerOffset)

        map = @chapter.map

        # Make sure we don't scroll outside the bounds of the map
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

        # Check that we actually need to move the viewport
        # (as opposed to keeping it in the same place)
        if not @direction.equals(new Position(0, 0))
            @direction = @direction.toUnitVector()
            if not @scrollSpeed?
                @scrollSpeed = .2
        else
            @direction = null

    centerElement: (el, padding) ->
        # It's hard/impossible to vertically center an element using
        # CSS alone, so this function takes care of the absolute positioning
        # by using the dimensions of the <canvas>
        css = {}
        css.top = (@canvas.height()-el.height())/2 - padding
        css.left = (@canvas.width()-el.width())/2 - padding
        return css

    render: ->
        # Tell the 'children' of this object to paint themselves on the canvas
        if @chapter?
            @chapter.render(this, @ctx)

        @cursor.render(this, @ctx)

    update: (delta) ->
        # Update function called by the main game loop.
        # Advances all animations based on the number of ms `delta`
        # that have elapsed since the last update
        delta *= @speedMultiplier

        # Viewport scrolling
        if @direction?
            @origin = @origin.add(
                @direction.scale(delta*@scrollSpeed))

            alt = @scrollDest.scale(@tw).subtract(@origin)

            if alt.dot(@direction) <= 0
                @origin = @scrollDest.scale(@tw)
                @direction = null

                if @scrollCallback?
                    @scrollCallback()

        # Unit attack lunge and movement
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
        # Main game loop. Relies on requestAnimationFrame for the looping
        now = Date.now()
        delta = now - @then
        @then = now

        @update(delta)
        requestAnimationFrame(@mainLoop)
        @render()


class _cs.chapterui.Chapter extends _cs.ControlState
    # ControlState from which all other control states used when
    # playing a chapter inherit from. Abstract class.
    # Pressing v toggles 3x speed

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

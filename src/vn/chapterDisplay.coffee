class _vn.ChapterDisplay

    constructor: (@ui) ->
        @display = @ui.vn.wrapper.find('.chapter-display')
        @fadeDelay = 2000

    init: (number, name, @callback) ->
        @ui.controlState = new _cs.vn.ChapterDisplay(@ui, this)
        @callbackMade = false
        @afterFadeInCalled = false

        @display.find('.number').text(number)
        @display.find('.name').text(name)

        @ui.vn.bgEl.hide()
        @ui.vn.setBackgroundImage('chapter_display.png')

        @toFade = @ui.vn.bgEl.add(@display)
        @toFade.fadeIn(@fadeDelay, @afterFadeIn)

    afterFadeIn: =>
        if not @afterFadeInCalled
            @afterFadeInCalled = true
            setTimeout(@afterWait, 3000)

    afterWait: =>
        if not @callbackMade
            @toFade.fadeOut(@fadeDelay, @done)

    skip: ->
        @toFade.hide()
        @done()

    done: =>
        @ui.controlState = new _cs.ControlState(@ui)

        if not @callbackMade
            @callbackMade = true
            @callback()

class _cs.vn.ChapterDisplay extends _cs.ControlState

    constructor: (@ui, @displayObj) ->

    v: ->

        @displayObj.skip()

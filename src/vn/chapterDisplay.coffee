class _vn.ChapterDisplay

    constructor: (@ui) ->
        @display = @ui.wrapper.find('.chapter-display')
        @fadeDelay = 2000

    init: (number, name, @callback) ->
        @ui.controlState = new _cs.vn.ChapterDisplay(@ui, this)
        @callbackMade = false

        @display.find('.number').text(number)
        @display.find('.name').text(name)

        _vn.setBackgroundImage(@display, 'chapter_display.png')
        @display.fadeIn(@fadeDelay, @afterFadeIn)

    afterFadeIn: =>
        setTimeout(@afterWait, 3000)

    afterWait: =>
        if not @callbackMade
            @display.fadeOut(@fadeDelay, @done)

    skip: ->
        @display.hide()
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

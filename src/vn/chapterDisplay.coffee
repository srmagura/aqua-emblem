class _vn.ChapterDisplay

    constructor: (@ui) ->
        @display = @ui.vn.wrapper.find('.chapter-display')
        @fadeDelay = 2000

    init: (number, name, @callback) ->
        @ui.controlState = new _cs.vn.ChapterDisplay(@ui, this)

        @display.find('.number').text(number)
        @display.find('.name').text(name)

        @ui.vn.bgEl.hide()
        @ui.vn.setBackgroundImage('chapter_display_background.png')

        @toFade = @ui.vn.bgEl.add(@display)
        @toFade.fadeIn(@fadeDelay).promise().done(@afterFadeIn)

    afterFadeIn: =>
        setTimeout(@afterWait, 3000)

    afterWait: =>
        @toFade.fadeOut(@fadeDelay).promise().done(@callback)

    skip: ->
        @toFade.hide()
        @done()

    done: ->
        @ui.controlState = new _cs.ControlState(@ui)
        @callback()

class _cs.vn.ChapterDisplay extends _cs.ControlState

    constructor: (@ui, @displayObj) ->

    v: ->
        @displayObj.skip()

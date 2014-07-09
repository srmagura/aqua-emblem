class _vn.ChapterDisplay

    constructor: (@ui) ->
        @display = @ui.vn.wrapper.find('.chapter-display')
        @fadeDelay = 2000

    init: (number, name, @callback) ->
        @display.find('.number').text(number)
        @display.find('.name').text(name)

        @ui.vn.bgEl.hide()
        @ui.vn.setBackgroundImage('chapter_display_background.png')

        @toFade = @ui.vn.bgEl.add(@display)
        @toFade.fadeIn(@fadeDelay, @afterFadeIn)

    afterFadeIn: =>
        setTimeout(@afterWait, 3000)

    afterWait: =>
        @toFade.fadeOut(@fadeDelay, @callback)

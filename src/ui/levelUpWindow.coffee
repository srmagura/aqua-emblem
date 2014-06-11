class window.LevelUpWindow

    constructor: (@ui) ->
        @window = $('.level-up-window')

    init: (@unit, @increment) ->
        @prevControlState = @ui.controlState
        @ui.controlState = new CsWindow(@ui, this)

        css = @ui.centerElement(@window, 4)
        css.visibility = 'visible'
        @window.css(css)

class window.LevelUpWindow

    constructor: (@ui) ->
        @window = $('.level-up-window')

    init: (@unit, @increment) ->
        @initCommon()
        @initStats()

        @prevControlState = @ui.controlState
        @ui.controlState = new CsWindow(@ui, this)

        css = @ui.centerElement(@window, 4)
        css.visibility = 'visible'
        @window.css(css)

    initCommon: ->
        @ui.viewportOverlay.show()

        w = @window

        w.find('.common .image-wrapper').removeClass('insignia')
        w.find('.common img').attr('src',
        'images/characters/' + @unit.name.toLowerCase() + '.png')

        w.find('.common .name').html(@unit.name)
        w.find('.common .level').text(@unit.level)

    initStats: ->
        stats = @window.find('.stats')
        statTypes = ['hp', 'mp', 'str', 'skill', 'mag',
            'speed', 'def', 'luck',
            'res', 'move']

        for st in statTypes
            stats.find('.' + st + ' span').text(@unit[st])

    hide: ->
        @ui.viewportOverlay.hide()
        @window.css('visibility', 'hidden')

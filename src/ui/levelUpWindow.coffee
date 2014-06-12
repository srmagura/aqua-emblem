class window.LevelUpWindow

    constructor: (@ui) ->
        @window = $('.level-up-window')

    init: (@unit, @increment) ->
        @initCommon()
        @initStats()

        @prevControlState = @ui.controlState
        @ui.controlState = new ControlState(@ui)

        css = @ui.centerElement(@window, 4)
        css.visibility = 'visible'
        @window.css(css)

        @incIndex = 0
        @delay = 750
        setTimeout(@showIncrement, @delay)

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

    showIncrement: =>
        if @incIndex == @increment.length
            @ui.controlState = new CsLevelUpWindow(@ui, this)
            return

        st = @increment[@incIndex]
        el = @window.find(".stats .#{st}")
        el.find('span').text(@unit[st] + 1)
        el.addClass('stat-up')
        el.find('img').css('visibility', 'visible')

        @incIndex++
        setTimeout(@showIncrement, @delay/2)

    hide: ->
        @ui.viewportOverlay.hide()
        @window.css('visibility', 'hidden')
        @window.find('.stat img').css('visibility', 'hidden')

class CsLevelUpWindow extends CsWindow
    f: -> @d()

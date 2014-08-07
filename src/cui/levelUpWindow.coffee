class _cui.LevelUpWindow

    constructor: (@ui) ->
        @window = $('.level-up-window')

    init: (@unit, @increment, @callback) ->
        @initCommon()
        @initStats()

        @ui.controlState = new _cs.cui.Chapter(@ui)

        css = @ui.centerElement(@window, 4)
        css.visibility = 'visible'
        @window.css(css)

        @incIndex = 0
        @incSize = 0
        for st of @increment
            @incSize++

        @delay = 750 / @ui.speedMultiplier
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
        @statTypes = ['maxHp', 'str', 'mag', 'def', 'res',
            'maxMp', 'skill', 'speed', 'luck', 'move']

        for st in @statTypes
            el = stats.find('.' + st)
            el.find('span').text(@unit.baseStats[st])
            el.removeClass('stat-up')

    showIncrement: =>
        while true
            if @incIndex == @statTypes.length
                @ui.controlState = new _cs.cui.LevelUpWindow(@ui, this)
                @window.find('.continue').css('visibility', 'visible')
                return

            st = @statTypes[@incIndex++]
            if st of @increment
                break

        el = @window.find(".stats .#{st}")
        el.find('span').text(@unit.baseStats[st] + 1)
        el.addClass('stat-up')
        el.find('img').css('visibility', 'visible')

        setTimeout(@showIncrement, @delay/2)

    hide: ->
        @ui.viewportOverlay.hide()
        @window.css('visibility', 'hidden')
        @window.find('.stat img, .continue').css('visibility', 'hidden')

class _cs.cui.LevelUpWindow extends _cs.cui.Chapter

    constructor: (@ui, @windowObj) ->

    f: -> @d()

    d: ->
        @ui.controlState = new _cs.cui.Chapter(@ui)
        @windowObj.hide()
        @windowObj.callback()

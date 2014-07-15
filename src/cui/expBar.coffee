class _cui.ExpBar

    constructor: (@ui) ->
        @container = $('.exp-bar-container')

    init: (unit, toAdd, callback) ->
        css = @ui.centerElement(@container, 5)
        @container.css(css)

        totalWidth = @container.find('.exp-bar').width()
        width0 = totalWidth * unit.exp

        barFilled = @container.find('.exp-bar-filled')
        barFilled.width(width0)

        afterAnimateLevelUp = =>
            time = msPerExp * (newExp - 1)
            width2 = (newExp - 1)*totalWidth

            barFilled.css('width', 0)
            barFilled.animate({width: width2}, time, afterAnimate)

        afterAnimate = =>
            setTimeout(afterDelay, 1000 / @ui.speedMultiplier)

        afterDelay = =>
            @hide()
            callback()

        @show()
        newExp = unit.exp + toAdd

        msPerExp = 1500 / @ui.speedMultiplier

        if newExp >= 1
            time = msPerExp * (1 - unit.exp)
            barFilled.animate({width: totalWidth}, time, afterAnimateLevelUp)
        else
            width1 = totalWidth * newExp
            barFilled.animate({width: width1}, msPerExp * toAdd, afterAnimate)

    show: ->
        @container.css('visibility', 'visible')

    hide: ->
        @container.css('visibility', 'hidden')

class window.ExpBar

    constructor: (@ui) ->
        @container = $('.exp-bar-container')

    init: (unit, toAdd, callback) ->
        css = @ui.centerElement(@container, 5)
        @container.css(css)

        totalWidth = @container.find('.exp-bar').width()
        width0 = totalWidth * unit.exp
        width1 = totalWidth * (unit.exp + toAdd)

        barFilled = @container.find('.exp-bar-filled')
        barFilled.width(width0)

        @show()

        afterDelay = =>
            @hide()
            callback()

        afterAnimate = =>
            setTimeout(afterDelay, 1000)

        barFilled.animate({width: width1}, 400, afterAnimate)


    show: ->
        @container.css('visibility', 'visible')

    hide: ->
        @container.css('visibility', 'hidden')

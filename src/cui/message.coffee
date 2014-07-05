class window.CanvasOverlay

    constructor: (@ui) ->
        @overlay = $('.canvas-dark-overlay')

    init: ->
        @overlay.css({
            width: @ui.canvas.width()
            height: @ui.canvas.height()
        })

    show: ->
        @overlay.css('display', 'block')

    hide: ->
        @overlay.css('display', 'none')

class window.MessageBox

    constructor: (@ui) ->
        @canvasContainer = $('.canvas-container')
        @ui.canvasOverlay.init()

    showMessage: (text, cls, css, callback, callbackArg, doFadeOut) ->
        el = $(document.createElement('div'))
        el.addClass('message').addClass(cls).text(text)
        @canvasContainer.append(el)

        css = $.extend(css, @ui.centerElement(el, 10))
        css.visibility = 'visible'
        css.display = 'none'

        fadeDuration = 800 / @ui.speedMultiplier
        @ui.canvasOverlay.init()
        @ui.canvasOverlay.overlay.fadeIn(fadeDuration)
        el.css(css).fadeIn(fadeDuration)

        afterFadeOut = =>
            callback(callbackArg)

        toDelay = =>
            @ui.canvasOverlay.overlay.fadeOut(fadeDuration)
            el.fadeOut(fadeDuration, afterFadeOut)

        if doFadeOut
            setTimeout(toDelay, fadeDuration*2)

    showPhaseMessage: (team, callback) ->
        ch = @ui.chapter
        css = {}

        if team is ch.playerTeam
            text = 'Player phase'
            css.color = '#00C'
        else
            text = 'Enemy phase'
            css.color = '#C00'

        @showMessage(text, 'phase-message', css, callback, team, true)


    showVictoryMessage: ->
        @showMessage('Victory!', 'victory-message', {}, (->), null, false)

    showDefeatMessage: ->
        @showMessage('Defeat.', 'defeat-message', {}, (->), null, false)

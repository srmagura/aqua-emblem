class window.MessageBox

    constructor: (@ui) ->
        @canvasContainer = $('.canvas-container')
        @overlay = $('.canvas-dark-overlay')
        cpos = @ui.canvas.position()
        @overlay.css({
            top: cpos.top
            left: cpos.left
            width: @ui.canvas.width()
            height: @ui.canvas.height()
        })

    showMessage: (text, cls, css, callback, callbackArg, doFadeOut) ->
        el = $(document.createElement('div'))
        el.addClass('message').addClass(cls).text(text)
        @canvasContainer.append(el)

        cpos = @ui.canvas.position()
        padding = 10

        css.top = cpos.top +
        (@ui.canvas.height()-el.height())/2 - padding
        css.left = cpos.left +
        (@ui.canvas.width()-el.width())/2 - padding

        css.visibility = 'visible'
        css.display = 'none'

        fadeDuration = 800
        @overlay.fadeIn(fadeDuration)
        el.css(css).fadeIn(fadeDuration)

        afterFadeOut = =>
            callback(callbackArg)

        toDelay = =>
            @overlay.fadeOut(fadeDuration)
            el.fadeOut(fadeDuration, afterFadeOut)

        if doFadeOut
            setTimeout(toDelay, fadeDuration*2)

    showPhaseMessage: (team, callback) ->
        ch = @ui.chapter
        css = {}

        if team is ch.playerTeam
            text = 'Player phase'
            css.color = 'blue'
        else
            text = 'Enemy phase'
            css.color = 'red'

        @showMessage(text, 'phase-message', css, callback, team, true)


    showVictoryMessage: ->
        @showMessage('Victory!', 'victory-message', {}, (->), null, false)

    showDefeatMessage: ->
        @showMessage('Defeat.', 'defeat-message', {}, (->), null, false)

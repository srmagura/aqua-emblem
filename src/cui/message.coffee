class _cui.CanvasOverlay

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

class _cui.MessageBox

    constructor: (@ui) ->
        @canvasContainer = $('.canvas-container')
        @ui.canvasOverlay.init()

    showMessage: (params) ->
        el = $('<div></div>').addClass(params.cls)
        el.addClass('message-box').html(params.html)
        @canvasContainer.append(el)

        css = $.extend(params.css, @ui.centerElement(el, 10))
        css.visibility = 'visible'
        css.display = 'none'

        fadeDuration = 800 / @ui.speedMultiplier
        @ui.canvasOverlay.init()
        @ui.canvasOverlay.overlay.fadeIn(fadeDuration)
        el.css(css).fadeIn(fadeDuration)

        afterFadeOut = =>
            if params.callback?
                el.remove()
                params.callback()

        toDelay = =>
            @ui.canvasOverlay.overlay.fadeOut(fadeDuration)
            el.fadeOut(fadeDuration, afterFadeOut)

        if params.doFadeOut
            setTimeout(toDelay, fadeDuration*2)
        else
            setTimeout(afterFadeOut, fadeDuration*2)

    showPhaseMessage: (team, callback) ->
        css = {}

        if team instanceof _team.PlayerTeam
            text = 'Player phase'
            css.color = '#00C'
        else
            text = 'Enemy phase'
            css.color = '#C00'
       
        @showMessage({
            html: text,
            cls: 'big-message phase-message',
            css: css, 
            callback: (-> callback(team))
            doFadeOut: true
        })

    showVictoryMessage: ->
        @showMessage({
            html: 'Victory!',
            cls: 'big-message victory-message',
            css: {},
            callback: @ui.doneVictory, 
            doFadeOut: false
        })

    showDefeatMessage: ->
        @showMessage({
            html: 'Defeat.',
            cls: 'big-message defeat-message',
            css: {},
            callback: @ui.doneDefeat, 
            doFadeOut: false
        })
            
    showBrokenMessage: (item, callback) ->
        content = $('<div> <div class="text">broke.</div></div>')
        content.prepend(item.getElement({showUses: false}))
        @showMessage({
            html: content,
            cls: 'neutral-box item-message',
            css: {},
            callback: null,
            doFadeOut: false
        })

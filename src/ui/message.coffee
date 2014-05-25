class window.MessageBox

    constructor: (@ui) ->
        @mbox = $('.message')

    showPhaseMessage: (team, callback) ->
        ch = @ui.chapter
        css = {}

        if team is ch.playerTeam
            text = 'Player phase'
            css.color = 'blue'
        else
            text = 'Enemy phase'
            css.color = 'red'

        textEl = $(document.createElement('div'))
        textEl.css(css).addClass('phase-message').text(text)
        @mbox.html('').append(textEl)

        fadeDuration = 400
        textEl.fadeIn(fadeDuration)

        afterFadeOut = =>
            @mbox.html('')
            callback(team)

        toDelay = =>
            textEl.fadeOut(fadeDuration, afterFadeOut)

        setTimeout(toDelay, fadeDuration*4)

    showVictoryMessage: ->
        textEl = $(document.createElement('div'))
        textEl.addClass('victory-message').text('Victory!')
        @mbox.html('').append(textEl)
        textEl.fadeIn('slow')

    showDefeatMessage: ->
        textEl = $(document.createElement('div'))
        textEl.addClass('defeat-message').text('Defeat.')
        @mbox.html('').append(textEl)
        textEl.fadeIn('slow')

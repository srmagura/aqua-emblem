class window.MessageBox

    constructor: ->
        @mbox = $('.message')

    showPhaseMessage: (teamId, callback) ->
        css = {}

        if(teamId == TEAM_PLAYER)
            text = 'Player phase'
            css.color = 'blue'
        else if(teamId == TEAM_ENEMY)
            text = 'Enemy phase'
            css.color = 'red'
        

        textEl = $(document.createElement('div'))
        textEl.css(css).addClass('phase-message').text(text)
        @mbox.html('').append(textEl)

        fadeDuration = 400
        textEl.fadeIn(fadeDuration)

        afterFadeOut = ->
            @mbox.html('')
            callback(teamId)

        toDelay = ->
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

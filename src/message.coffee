showPhaseMessage = (teamId, callback) ->
    css = {}

    if(teamId == TEAM_PLAYER)
        text = 'Player phase'
        css.color = 'blue'
    else if(teamId == TEAM_ENEMY)
        text = 'Enemy phase'
        css.color = 'red'
    

    mbox = $(document.createElement('div'))
    mbox.css(css).addClass('phase-message').text(text)
    $('.message').html('').append(mbox)

    fadeDuration = 400
    mbox.fadeIn(fadeDuration)

    setTimeout(
        ->
            mbox.fadeOut(fadeDuration,
                ->
                    $('.message').html('')
                    callback(teamId)
            )
        , fadeDuration*4)

showVictoryMessage = ->
    mbox = $(document.createElement('div'))
    mbox.addClass('victory-message').text('Victory!')
    $('.message').html('').append(mbox)
    mbox.fadeIn('slow')

showDefeatMessage = ->
    mbox = $(document.createElement('div'))
    mbox.addClass('defeat-message').text('Defeat.')
    $('.message').html('').append(mbox)
    mbox.fadeIn('slow')

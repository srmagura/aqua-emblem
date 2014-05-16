function showPhaseMessage(teamId, callback){
    var text
    var css = {}

    if(teamId == TEAM_PLAYER){
        text = 'Player phase'
        css.color = 'blue'
    } else if(teamId == TEAM_ENEMY){
        text = 'Enemy phase'
        css.color = 'red'
    }

    var span = $(document.createElement('span')) 
    span.css(css).addClass('phase-message').text(text)
    $('.message').html('').append(span)

    var fadeDuration = 400
    span.fadeIn(fadeDuration)

    setTimeout(function(){
        span.fadeOut(fadeDuration, function(){
            $('.message').html('')
            callback(teamId)
        })
    }, fadeDuration*4)
}

function showVictoryMessage(){
    var span = $(document.createElement('span')) 
    span.addClass('victory-message').text('Victory!')
    $('.message').html('').append(span)
    span.fadeIn('slow')
}

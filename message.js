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

    var mbox = $(document.createElement('div')) 
    mbox.css(css).addClass('phase-message').text(text)
    $('.message').html('').append(mbox)

    var fadeDuration = 400
    mbox.fadeIn(fadeDuration)

    setTimeout(function(){
        mbox.fadeOut(fadeDuration, function(){
            $('.message').html('')
            callback(teamId)
        })
    }, fadeDuration*4)
}

function showVictoryMessage(){
    var mbox = $(document.createElement('div')) 
    mbox.addClass('victory-message').text('Victory!')
    $('.message').html('').append(mbox)
    mbox.fadeIn('slow')
}

function showDefeatMessage(){
    var mbox = $(document.createElement('div')) 
    mbox.addClass('defeat-message').text('Defeat.')
    $('.message').html('').append(mbox)
    mbox.fadeIn('slow')
}

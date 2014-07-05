window._status = {}

class _status.Status

    constructor: ->

    getEl: ->
        div = $('<div></div>').addClass('status')
        img = $('<img/>').attr('src', @imagePath)
        span = $('<span></span>').text(@text)

        div.append(img).append(span)
        return div

class _status.Defend extends _status.Status

    constructor: ->
        @text = 'Defend'
        @imagePath = 'images/skills/defend.png'
        @turns = 1

window._status = {}

class _status.Status

    constructor: ->

    newTurn: ->
        @turns--
        return @turns > 0

    getEl: ->
        div = $('<div></div>').addClass('status')
        
        clsName = @constructor.name.toLowerCase()
        div.addClass('status-' + clsName)

        img = $('<img/>').attr('src', @getImagePath())
        span = $('<span></span>').html(@text)

        div.append(img).append(span)
        return div

    getImagePath: ->
        return 'images/' + @imagePath

class _status.Defend extends _status.Status

    constructor: ->
        @text = 'Defend'
        @imagePath = 'skills/defend.png'
        @turns = 1

class _status.Buff extends _status.Status

    constructor: (@stat) ->
        @imagePath = 'up_arrow.png'
        @turns = 3
        @value = @turns
        @updateText()

    updateText: ->
        @text = "<span class='stat'>#{@stat.toUpperCase()}</span>"
        @text += ' +' + @value

    newTurn: ->
        @value--
        @updateText()
        super()

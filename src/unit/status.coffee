window._status = {}

class _status.Status

    newTurn: ->
        @turns--
        return @turns > 0

    getEl: ->
        div = $('<div></div>').addClass('status')
        
        clsName = _util.getFunctionName(@constructor).toLowerCase()
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

    constructor: (@stat, @value) ->
        @imagePath = 'up_arrow.png'
        @turns = @value
        @updateText()

    updateText: ->
        @text = "<span class='stat'>#{@stat.toUpperCase()}</span>"
        @text += ' +' + @value

    newTurn: ->
        @value--
        @updateText()
        super()
        
class _status.Poison extends _status.Status

    constructor: (@dmg) ->
        @imagePath = 'skills/poison_arrow.png'
        @turns = 3
        @updateText()
        
     updateText: ->
        @text = "Poison (#{@turns})"
        
     newTurn: ->
        super()
        @dmg -= 2
        
        if @dmg <= 0
            @dmg = 1
            
        @updateText()
       
class _status.PoisonAction

    getMessageEl: ->
        return _skill.getMessageEl({
            imagePath: 'images/skills/poison_arrow.png',
            text: 'Poison'
        })

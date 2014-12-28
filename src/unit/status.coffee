window._status = {}

class _status.Status

    replaceOther: false
    
    onEnemyTurn: ->

    newTurn: (unit) -> @turns--

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

    newTurn: (unit) ->
        @value--
        @updateText()
        super()
        
class _status.Poison extends _status.Status

    constructor: (@dmg) ->
        @imagePath = 'skills/poison_arrow.png'
        @turns = 3
        @replaceOther = true
        @updateText()
        
     updateText: ->
        @text = "Poison (#{@turns})"
        
     newTurn: (unit) ->
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
        
class _status.ThrowingKnives extends _status.Status

    constructor: ->
        @imagePath = 'skills/throwing_knives.png'
        @turns = 3
        @replaceOther = true
        @updateText()
        
    updateText: ->
        @text = "Throwing Knives (#{@turns})"
        
    newTurn: (unit) ->
        super(unit)
        @updateText()
        
        if unit.inventory.items[0] instanceof _item.ThrowingKnives
            unit.inventory.remove(0)
        
    onEnemyTurn: (unit) ->
        unit.inventory.prepend(new _item.ThrowingKnives())
        unit.inventory.refresh()

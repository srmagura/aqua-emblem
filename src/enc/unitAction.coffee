class _enc.UnitAction

    constructor: (@ui, @unit) ->

    doAction: (@action, @callback, @delta) ->
        @container = $('<div></div>')
        @container.addClass('unit-action-container').
        appendTo('.canvas-container')

        boxEl = $('.sidebar .unit-info').clone().addClass('blue-box')
        @container.append(boxEl)

        @box = new _cui.UnitInfoBox(@ui, boxEl)
        @box.init(@unit, false, false)
        @box.show()

        tw = @ui.tw

        left0 = (@unit.pos.j+.5)*tw - @ui.origin.j

        css = {}
        css.left = left0 - boxEl.width()/2
        css.top = (@unit.pos.i + 1)*tw + 5 - @ui.origin.i
        @container.css(css)

        if @action.getMessageEl?
            @message = @action.getMessageEl()
            @message.appendTo(@container)
            
            if @unit.team instanceof _team.PlayerTeam
                @message.addClass('blue-box')
            else
                @message.addClass('red-box')

        afterFadeIn = =>
            setTimeout(afterDelay, @delay*4/3)

            if @action instanceof _skill.Skill
                @unit.mp -= @action.mp
                
            if @delta? and 'hp' of @delta
                @unit.addHp(@delta.hp)

            @box.init(@unit, true, false)

        afterDelay = =>
            @container.fadeOut(@delay/3)
            @message.fadeOut(@delay/3, @callback)

        @delay = _enc.DELAY / @ui.speedMultiplier
        @message.fadeIn(@delay/3, afterFadeIn)

class window.UnitAction

    constructor: (@ui, @unit) ->

    doAction: (@action, @callback) ->
        @container = $('<div></div>')
        @container.addClass('unit-action-container').
        appendTo('.canvas-container')

        boxEl = $('.sidebar .unit-info').clone().addClass('blue-box')
        @container.append(boxEl)

        @box = new UnitInfoBox(@ui, boxEl)
        @box.populate(@unit, false)
        @box.show()

        tw = @ui.tw

        left0 = (@unit.pos.j+.5)*tw - @ui.origin.j

        css = {}
        css.left = left0 - boxEl.width()/2
        css.top = (@unit.pos.i + 1)*tw + 5 - @ui.origin.i
        @container.css(css)

        if @action instanceof skill.Skill
            @message = @action.getMessageEl()
            @message.addClass('blue-box').appendTo(@container)

        afterFadeIn = =>
            setTimeout(afterDelay, @delay*4)

        afterDelay = =>
            @container.fadeOut(@delay)
            @message.fadeOut(@delay, @callback)

        @delay = 600
        @message.fadeIn(@delay, afterFadeIn)

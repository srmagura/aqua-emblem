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

        @message = $('<div></div>').appendTo(@container)
        @message.addClass('action-message')

        if @action instanceof skill.Skill
            imgSrc = @action.getImagePath()
            text = skill.name + '!'

        img = $('<img/>').attr('src', imgSrc)
        img.appendTo(@message)

        span = $('<span></span>').text(text)
        span.appendTo(@message)

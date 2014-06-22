WIDTH = 4
HEIGHT = 4

class window.SkillsBox

    constructor: (@ui, @box, @onD) ->

    init: (@unit) ->
        @box.html('')

        for i in [0..@unit.skills.length-1]
            if i % WIDTH == 0
                tr = $('<tr></tr>').appendTo(@box)

            td = $('<td></td>').appendTo(tr)
            td.addClass('skill')

            skl = @unit.skills[i]
            img = $('<img />').attr('src', skl.getImagePath()).
                appendTo(td)

        while i < WIDTH
            $('<td></td>').appendTo(tr)

    giveControl: ->
        @setCursorPos(new Position(0, 0))
        @ui.controlState = new CsSkillsBox(@ui, this)

    getCell: (pos) ->
        row = $(@box.find('tr')[pos.i])
        return $(row.find('td')[pos.j])

    getCursorCell: ->
        return @getCell(@cursorPos)

    setCursorPos: (@cursorPos) ->
        @box.find('.selected').removeClass('selected')
        @getCursorCell().addClass('selected')

class CsSkillsBox extends ControlState

    constructor: (@ui, @boxObj) ->

    skillAt: (cp) -> @boxObj.getCell(cp).hasClass('skill')

    d: ->
        @boxObj.box.find('.selected').removeClass('selected')
        @boxObj.onD()

    left: ->

    right: ->
        cp = @boxObj.cursorPos

        if cp.j + 1 < WIDTH
            cp1 = new Position(cp.i, cp.j+1)
            if @skillAt(cp1)
                @boxObj.setCursorPos(cp1)
        else
            for j in [0..WIDTH-1]
                cp1 = new Position(cp.i, j)
                if @skillAt(cp1)
                    @boxObj.setCursorPos(cp1)
                    break

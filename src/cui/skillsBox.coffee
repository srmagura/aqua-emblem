WIDTH = 4
HEIGHT = 4

class _cui.SkillsBox

    constructor: (@ui, @box, @skillInfoBox) ->

    init: (@unit, @onD, @onCursorMove) ->
        @box.html('')

        for i in [0..@unit.skills.length-1]
            if i % WIDTH == 0
                tr = $('<tr></tr>').appendTo(@box)

            td = $('<td></td>').appendTo(tr)
            td.addClass('skill')

            skl = @unit.skills[i]
            img = $('<img />').attr('src', skl.getImagePath()).
                appendTo(td)
            td.data('skill', skl)

        i %= WIDTH
        while i < WIDTH
            $('<td></td>').appendTo(tr)
            i++

        @show()

    giveControl: ->
        @setCursorPos(new Position(0, 0))
        @ui.controlState = new _cs.SkillsBox(@ui, this)

    getSkill: ->
        return @getCursorCell().data('skill')

    getCell: (pos) ->
        row = $(@box.find('tr')[pos.i])
        return $(row.find('td')[pos.j])

    getCursorCell: ->
        return @getCell(@cursorPos)

    setCursorPos: (@cursorPos) ->
        if @onCursorMove?
            @onCursorMove()

        @box.find('.selected').removeClass('selected')
        @getCursorCell().addClass('selected')
        @updateInfoBox()

    updateInfoBox: ->
        skl = @getSkill()
        @skillInfoBox.init(skl, @unit.canUseSkill(skl))

    show: ->
        @box.css('display', 'block')

    hide: ->
        @box.css('display', 'none')

class _cs.SkillsBox extends _cs.Chapter

    constructor: (@ui, @boxObj) ->

    skillAt: (cp) -> @boxObj.getCell(cp).hasClass('skill')

    f: ->
        @boxObj.onF()

    d: ->
        @boxObj.box.find('.selected').removeClass('selected')
        @boxObj.skillInfoBox.hide()
        @boxObj.onD()

    left: ->
        cp = @boxObj.cursorPos

        if cp.j > 0
            cp1 = new Position(cp.i, cp.j-1)
            @boxObj.setCursorPos(cp1)
        else
            for j in [WIDTH-1..0]
                cp1 = new Position(cp.i, j)
                if @skillAt(cp1)
                    @boxObj.setCursorPos(cp1)
                    break

    right: ->
        cp = @boxObj.cursorPos
        cp1 = new Position(cp.i, cp.j+1)

        if not (cp.j + 1 < WIDTH and @skillAt(cp1))
            cp1 = new Position(cp.i, 0)

        @boxObj.setCursorPos(cp1)

    up: ->
        cp = @boxObj.cursorPos

        if cp.i > 0
            cp1 = new Position(cp.i-1, cp.j)
            @boxObj.setCursorPos(cp1)
        else
            for i in [WIDTH-1..0]
                cp1 = new Position(i, cp.j)
                if @skillAt(cp1)
                    @boxObj.setCursorPos(cp1)
                    break

    down: ->
        cp = @boxObj.cursorPos
        cp1 = new Position(cp.i+1, cp.j)

        if not (cp1.i < HEIGHT and @skillAt(cp1))
            cp1 = new Position(0, cp.j)

        @boxObj.setCursorPos(cp1)

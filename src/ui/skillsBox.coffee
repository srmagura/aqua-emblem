class window.SkillsBox

    constructor: (@ui, @box) ->

    init: (@unit) ->
        @box.html('')

        for i in [0..@unit.skills.length-1]
            if i % 4 == 0
                tr = $('<tr></tr>').appendTo(@box)

            td = $('<td></td>').appendTo(tr)
            skl = @unit.skills[i]
            img = $('<img />').attr('src', skl.getImagePath()).
                appendTo(td)

        while i < 4
            $('<td></td>').appendTo(tr)


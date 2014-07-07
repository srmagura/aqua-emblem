class _cui.SkillInfoBox

    constructor: (@ui, @box) ->

    init: (skill, usable, full=true) ->
        if not usable
            @box.addClass('not-usable')
        else
            @box.removeClass('not-usable')

        heading = @box.find('.heading')
        heading.find('img').attr('src', skill.getImagePath())
        heading.find('span').text(skill.name)

        stats = @box.find('.stats')
        desc = @box.find('.desc')
        rowMightRange = stats.find('.row-might-range')

        if full
            stats.show()
            stats.find('.mp').text(skill.mp)

            typeHalf = stats.find('.half-type')

            if skill.type is _skill.type.None
                typeHalf.hide()
            else
                typeHalf.show()
                stats.find('.type').html(skill.type.getEl())

            desc.text(skill.desc).show()

            if skill.might?
                stats.find('.might').text(skill.might)
                stats.find('.range').text(skill.range.toString())
                rowMightRange.show()
            else
                rowMightRange.hide()
        else
            stats.hide()
            desc.hide()

        @show()

    show: ->
        @box.css('display', 'block')

    hide: ->
        @box.css('display', 'none')

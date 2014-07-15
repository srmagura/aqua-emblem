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

        if full
            @initStats(skill, stats)
            desc.text(skill.desc).show()
        else
            stats.hide()
            desc.hide()

        @show()

    initStats: (skill, stats) ->
        getAttr = (key) ->
            if key == 'type' and skill.type instanceof _skill.type.None
                return null
            else if not skill[key]?
                return null

            if key == 'range'
                return skill[key].toString()
            else if key == 'type'
                return skill[key].getEl()
            else
                return skill[key]


        keys = ['mp', 'type', 'hit', 'might', 'crit', 'range']

        for key in keys
            html = getAttr(key)
            half = stats.find(".half-#{key}")

            if html?
                half.show()
                half.find('.value').html(html)
            else
                half.hide()

        stats.show()

    show: ->
        @box.css('display', 'block')

    hide: ->
        @box.css('display', 'none')

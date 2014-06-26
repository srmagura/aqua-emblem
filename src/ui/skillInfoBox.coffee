class window.SkillInfoBox

    constructor: (@ui, @box) ->

    init: (skl, full=true) ->
        heading = @box.find('.heading')
        heading.find('img').attr('src', skl.getImagePath())
        heading.find('span').text(skl.name)

        usage = @box.find('.usage-container')
        desc = @box.find('.desc')

        if full
            usage.find('.mp').text(skl.mp)
            usage.find('.cooldown').text(skl.cooldown)
            usage.show()
            desc.text(skl.desc).show()
        else
            usage.hide()
            desc.hide()

        @show()

    show: ->
        @box.css('display', 'block')

    hide: ->
        @box.css('display', 'none')

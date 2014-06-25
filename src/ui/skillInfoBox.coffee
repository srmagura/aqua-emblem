class window.SkillInfoBox

    constructor: (@ui, @box) ->

    init: (skl) ->
        heading = @box.find('.heading')
        heading.find('img').attr('src', skl.getImagePath())
        heading.find('span').text(skl.name)

        usage = @box.find('.usage')
        usage.find('.mp').text(skl.mp)
        usage.find('.cooldown').text(skl.cooldown)

        @box.find('.desc').text(skl.desc)

        @show()

    show: ->
        @box.css('visibility', 'visible')

    hide: ->
        @box.css('visibility', 'hidden')

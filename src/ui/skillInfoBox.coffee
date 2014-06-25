class window.SkillInfoBox

    constructor: (@ui, @box) ->

    init: (skl) ->
        @box.text(skl.name)
        @show()

    show: ->
        @box.css('visibility', 'visible')

    hide: ->
        @box.css('visibility', 'hidden')

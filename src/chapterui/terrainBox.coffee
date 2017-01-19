class _chapterui.TerrainBox

    constructor: (@ui) ->
        @box = $('.terrain-box')

    init: ->
        terrain = @ui.chapter.map.getTerrain(@ui.cursor.pos)

        @box.find('img').attr('src', terrain.image.src)
        @box.find('.name').text(terrain.name)

        if terrain.block
            evadeText = '--'
            defText = '--'
        else
            evadeText = terrain.evade
            defText = terrain.def

            if evadeText > 0
                evadeText = '+' + evadeText
            if defText > 0
                defText = '+' + defText

        @box.find('.evade').text(evadeText)
        @box.find('.def').text(defText)
        @show()

    show: ->
        @box.css('visibility', 'visible')

    hide: ->
        @box.css('visibility', 'hidden')

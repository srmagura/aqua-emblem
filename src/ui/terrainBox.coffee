class window.TerrainBox

    constructor: (@ui) ->
        @box = $('.terrain-box')

    init: ->
        terrain = @ui.chapter.map.getTerrain(@ui.cursor.pos)
        @box.text(terrain.name)
        @show()

    show: ->
        @box.css('display', 'block')

    hide: ->
        @box.css('display', 'none')

window._terrain = {}

class _terrain.Terrain

    constructor: (name) ->
        @evade = 0
        @def = 0
        @block = false

        @image = new Image()
        @image.src = "images/terrain/#{name}.png"

class _terrain.Plain extends _terrain.Terrain
    constructor: ->
        super('plain')
        @name = 'Plain'

class _terrain.Rocks extends _terrain.Terrain
    constructor: ->
        super('rocks')
        @name = 'Rocks'
        @block = true

class _terrain.Forest extends _terrain.Terrain
    constructor: ->
        super('forest')
        @name = 'Forest'
        @evade = 20
        @def = 1

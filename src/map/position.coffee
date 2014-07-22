class window.Position

    constructor: (@i, @j) ->

    clone: -> new Position(@i, @j)

    equals: (pos) ->
        @i == pos.i and @j == pos.j

    add: (pos) ->
        new Position(@i + pos.i, @j + pos.j)

    subtract: (pos) ->
        new Position(@i - pos.i, @j - pos.j)

    scale: (alpha) ->
        new Position(alpha*@i, alpha*@j)

    distance: (pos) ->
        Math.abs(@i - pos.i) + Math.abs(@j - pos.j)

    dot: (pos) ->
        return @i*pos.i + @j*pos.j

    norm: -> Math.sqrt(@i*@i + @j*@j)

    toUnitVector: -> @scale(1/@norm())

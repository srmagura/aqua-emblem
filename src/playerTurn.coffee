class Destination

    constructor: (@pos, @path) ->

class window.Turn

    constructor: (@ui) ->

    getAvailable: (unit) ->
        available = [new Destination(unit.pos, [unit.pos])]


class window.PlayerTurn extends Turn

    select: (@selectedUnit) ->
        @available = @getAvailable(@selectedUnit)

        for spot in @available
            @ui.chapter.map.setOverlay(spot.pos, 'available')

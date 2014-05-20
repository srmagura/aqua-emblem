class window.Position

    constructor: (@i, @j) ->

    equals: (pos) ->
        @i == pos.i && @j == pos.j

    add: (pos) ->
        new Position(@i + pos.i, @j + pos.j)

    subtract: (pos) ->
        new Position(@i - pos.i, @j - pos.j)

    scale: (alpha) ->
        new Position(alpha*@i, alpha*@j)

terrainTypes = {
    0: {color: '#BFB', block: false},
    1: {color: '#DDD', block: true}
}

OVERLAY_AVAILABLE = 1
OVERLAY_ATTACK = 2

overlayTileTypes = {
    1: {startColor: '#AAF', endColor: '#22F'},
    2: {startColor: '#FAA', endColor: '#F22'}
}

class window.Map

    constructor: (@tiles, @playerPositions) ->
        @height = @tiles.length
        @width = @tiles[0].length

        @overlayTiles = []
        for i in [0..@height-1]
            @overlayTiles.push([])
            for j in [0..@width-1]
                @overlayTiles[i].push(0)

    onMap: (pos) ->
        (0 <= pos.i and pos.i < @height and
            0 <= pos.j and pos.j < @width)

    clearOverlay: ->
        for i in [0..@height-1]
            for j in [0..@width-1]
                @overlayTiles[i][j] = 0

    render: (ui, ctx) ->
        tw = ui.tw
        cw = ui.canvas.width()

        ctx.fillStyle = 'white'
        ctx.fillRect(0, 0, cw, cw)

        for i in [0..@height-1]
            for j in [0..@width-1]
                x0 = j*tw
                y0 = i*tw

                ctx.fillStyle = terrainTypes[@tiles[i][j]].color
                ctx.fillRect(x0, y0, tw, tw)

                overlayTile = @overlayTiles[i][j]
                if overlayTile != 0
                    ctx.beginPath()
                    ctx.rect(x0, y0, tw, tw)

                    tileType = overlayTileTypes[overlayTile]

                    grd = ctx.createLinearGradient(
                        x0, y0, x0+tw, y0+tw)
                    grd.addColorStop(0, tileType.startColor)
                    grd.addColorStop(1, tileType.endColor)
                    ctx.fillStyle = grd
                    ctx.globalAlpha = .7
                    ctx.fill()
                    ctx.globalAlpha = 1

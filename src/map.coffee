class window.Position

    constructor: (@i, @j) ->

    clone: -> new Position(@i, @j)

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

OVERLAY_TYPES = {
    available: {startColor: '#AAF', endColor: '#22F'},
    attack: {startColor: '#FAA', endColor: '#F22'}
}

class window.Map

    constructor: (@tiles, playerPositions) ->
        @height = @tiles.length
        @width = @tiles[0].length

        @playerPositions = []
        for t in playerPositions
            @playerPositions.push(new Position(t[0], t[1]))

        @overlayTiles = []
        for i in [0..@height-1]
            @overlayTiles.push([])
            for j in [0..@width-1]
                @overlayTiles[i].push(null)

    onMap: (pos) ->
        (0 <= pos.i and pos.i < @height and
            0 <= pos.j and pos.j < @width)

    setOverlay: (pos, overlayType) ->
        @overlayTiles[pos.i][pos.j] = OVERLAY_TYPES[overlayType]

    clearOverlay: ->
        for i in [0..@height-1]
            for j in [0..@width-1]
                @overlayTiles[i][j] = null

    render: (ui, ctx) ->
        @renderTiles(ui, ctx)
        @renderGrid(ui, ctx)

    renderTiles: (ui, ctx) ->
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
                if overlayTile != null
                    ctx.beginPath()
                    ctx.rect(x0, y0, tw, tw)

                    grd = ctx.createLinearGradient(
                        x0, y0, x0+tw, y0+tw)
                    grd.addColorStop(0, overlayTile.startColor)
                    grd.addColorStop(1, overlayTile.endColor)
                    ctx.fillStyle = grd
                    ctx.globalAlpha = .7
                    ctx.fill()
                    ctx.globalAlpha = 1

    renderGrid: (ui, ctx) ->
        tw = ui.tw
        gridWidth = 2
        ctx.lineWidth = gridWidth
        ctx.strokeStyle = '#666'

        #horizontal
        for i in [0..@height]
            offset = 0
            if i == 0
                offset = gridWidth / 2
            else if i == @height
                offset = -gridWidth / 2

            ctx.beginPath()
            ctx.moveTo(offset, i*tw + offset)
            ctx.lineTo(@width*tw + offset, i*tw + offset)
            ctx.stroke()

        #vertical
        for j in [0..@width]
            offset = 0
            if j == 0
                offset = gridWidth / 2
            else if j == @width
                offset = -gridWidth / 2
            
            ctx.beginPath()
            ctx.moveTo(j*tw + offset, offset)
            ctx.lineTo(j*tw + offset, @height*tw + offset)
            ctx.stroke()

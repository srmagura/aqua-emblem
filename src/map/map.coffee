window._map = {}

_map.OVERLAY_TYPES = {
    AVAILABLE: {startColor: '#AAF', endColor: '#22F'},
    ATTACK: {startColor: '#FAA', endColor: '#F22'},
    AID: {startColor: '#AFA', endColor: '#2F2'},
    DAMAGE: {startColor: '#ffe6aa', endColor: '#d28704'}
}

class _map.Map

    constructor: (rawTiles, terrainMapping, playerPositions) ->
        @height = rawTiles.length
        @width = rawTiles[0].length

        @tiles = []
        for i in [0..@height-1]
            @tiles.push([])
            for j in [0..@width-1]
                @tiles[i].push(new terrainMapping[rawTiles[i][j]]())

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

    getTerrain: (pos) ->
        return @tiles[pos.i][pos.j]

    setOverlay: (pos, overlayType) ->
        @overlayTiles[pos.i][pos.j] = _map.OVERLAY_TYPES[overlayType]

    setOverlayRange: (pos, range, overlayType) ->
        @clearOverlay()
        spots = @ui.staticTurn.getActionRange(pos, range)

        for spot in spots
            @setOverlay(spot, overlayType)

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

        ctx.fillStyle = '#333'
        ctx.fillRect(0, 0, cw, cw)

        for i in [0..@height-1]
            for j in [0..@width-1]
                x0 = j*tw - ui.origin.j
                y0 = i*tw - ui.origin.i

                ctx.drawImage(@tiles[i][j].image, x0, y0)

                overlayTile = @overlayTiles[i][j]
                if overlayTile != null
                    ctx.beginPath()
                    ctx.rect(x0, y0, tw, tw)

                    grd = ctx.createLinearGradient(
                        x0, y0, x0+tw, y0+tw)
                    grd.addColorStop(0, overlayTile.startColor)
                    grd.addColorStop(1, overlayTile.endColor)
                    ctx.fillStyle = grd
                    ctx.globalAlpha = .55
                    ctx.fill()
                    ctx.globalAlpha = 1

    renderGrid: (ui, ctx) ->
        tw = ui.tw
        gridWidth = 2
        ctx.lineWidth = gridWidth

        borderColor = 'black'
        normalColor = 'black'
        normalAlpha = .10

        drawHorizontal = (i) =>
            offset = 0
            if i == 0
                offset = gridWidth / 2
            else if i == @height
                offset = -gridWidth / 2

            if i == 0 or i == @height
                ctx.strokeStyle = borderColor
            else
                ctx.strokeStyle = normalColor
                ctx.globalAlpha = normalAlpha

            ctx.beginPath()
            ctx.moveTo(offset, i*tw + offset - ui.origin.i)
            ctx.lineTo(@width*tw + offset,
            i*tw + offset - ui.origin.i)
            ctx.stroke()
            ctx.globalAlpha = 1

        drawVertical = (j) =>
            offset = 0
            if j == 0
                offset = gridWidth / 2
            else if j == @width
                offset = -gridWidth / 2

            if j == 0 or j == @width
                ctx.strokeStyle = borderColor
            else
                ctx.strokeStyle = normalColor
                ctx.globalAlpha = normalAlpha
            
            ctx.beginPath()
            ctx.moveTo(j*tw + offset - ui.origin.j,
            offset - ui.origin.i)
            ctx.lineTo(j*tw + offset - ui.origin.j, @height*tw + offset)
            ctx.stroke()
            ctx.globalAlpha = 1

        for i in [1..@height-1]
            drawHorizontal(i)

        for j in [1..@width-1]
            drawVertical(j)

        drawHorizontal(0)
        drawHorizontal(@height)

        drawVertical(0)
        drawVertical(@width)

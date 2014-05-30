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

    distance: (pos) ->
        Math.abs(@i - pos.i) + Math.abs(@j - pos.j)

    toUnitVector: ->
        norm = Math.sqrt(@i*@i + @j*@j)
        return this.scale(1/norm)

window.terrain = {}

class terrain.Terrain

class terrain.Plain extends terrain.Terrain
    constructor: ->
        @color = '#BFB'
        @block = false

class terrain.Thicket extends terrain.Terrain
    constructor: ->
        @color = '#A74'
        @block = true

class terrain.Forest extends terrain.Terrain
    constructor: ->
        @color = '#393'
        @block = false

window.OVERLAY_TYPES = {
    AVAILABLE: {startColor: '#AAF', endColor: '#22F'},
    ATTACK: {startColor: '#FAA', endColor: '#F22'}
}

class window.Map

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

        ctx.fillStyle = '#333'
        ctx.fillRect(0, 0, cw, cw)

        for i in [0..@height-1]
            for j in [0..@width-1]
                x0 = j*tw - ui.origin.j
                y0 = i*tw - ui.origin.i

                ctx.fillStyle = @tiles[i][j].color
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

        borderColor = 'black'
        normalColor = '#888'

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

            ctx.beginPath()
            ctx.moveTo(offset, i*tw + offset - ui.origin.i)
            ctx.lineTo(@width*tw + offset,
            i*tw + offset - ui.origin.i)
            ctx.stroke()

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
            
            ctx.beginPath()
            ctx.moveTo(j*tw + offset - ui.origin.j,
            offset - ui.origin.i)
            ctx.lineTo(j*tw + offset - ui.origin.j, @height*tw + offset)
            ctx.stroke()

        for i in [1..@height-1]
            drawHorizontal(i)

        for j in [1..@width-1]
            drawVertical(j)

        drawHorizontal(0)
        drawHorizontal(@height)

        drawVertical(0)
        drawVertical(@width)

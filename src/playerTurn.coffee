class Destination

    constructor: (@pos, @path) ->

    render: (ui, ctx) ->
        tw = ui.tw
        ctx.beginPath()

        k = 0
        while k < @path.length - 1
            ctx.moveTo(@path[k].j*tw + tw/2, @path[k].i*tw + tw/2)
            ctx.lineTo(@path[k+1].j*tw + tw/2, @path[k+1].i*tw + tw/2)
            k++

        if k > 0
            s = 10
            x0 = @pos.j*tw
            y0 = @pos.i*tw

            dir = @pos.subtract(@path[k-1])
            if dir.equals(new Position(1, 0))
                ctx.moveTo(x0+s, y0+s)
                ctx.lineTo(x0+tw/2, y0 + tw/2)
                ctx.lineTo(x0+tw-s, y0+s)
            else if dir.equals(new Position(-1, 0))
                ctx.moveTo(x0+s, y0+tw-s)
                ctx.lineTo(x0+tw/2, y0 + tw/2)
                ctx.lineTo(x0+tw-s, y0+tw-s)
            else if dir.equals(new Position(0, 1))
                ctx.moveTo(x0+s, y0+s)
                ctx.lineTo(x0+tw/2, y0 + tw/2)
                ctx.lineTo(x0+s, y0+tw-s)
            else if dir.equals(new Position(0, -1))
                ctx.moveTo(x0+tw-s, y0+s)
                ctx.lineTo(x0+tw/2, y0 + tw/2)
                ctx.lineTo(x0+tw-s, y0+tw-s)

            ctx.strokeStyle = '#2266FF'
            ctx.lineWidth = 7
            ctx.stroke()

            ctx.strokeStyle = '#3399FF'
            ctx.lineWidth = 3
            ctx.stroke()

            ctx.strokeStyle = '#5BF'
            ctx.lineWidth = 1
            ctx.stroke()

            ctx.lineWidth = 2


class window.Turn

    constructor: (@ui) ->

    getAvailable: (unit) ->
        available = [new Destination(unit.pos, [unit.pos])]

        queue = []

        map = @ui.chapter.map
        dist = Array(map.height)
        prev = Array(map.height)

        for i in [0..map.height-1]
            dist[i] = Array(map.width)
            prev[i] = Array(map.width)

            for j in [0..map.width-1]
                dist[i][j] = Infinity
                prev[i][j] = null
                queue.push(new Position(i, j))

        dist[unit.pos.i][unit.pos.j] = 0

        popClosest = ->
            minDist = Infinity

            for pos2, k in queue
                alt = dist[pos2.i][pos2.j]
                if alt < minDist
                    minDist = alt
                    minDistK = k

            return [queue.splice(minDistK, 1)[0], minDist]

        directions = [new Position(-1, 0), new Position(1, 0)
        new Position(0, -1), new Position(0, 1)]

        while queue.length != 0
            [pos, posDist] = popClosest()
            if posDist is Infinity
                break

            for k in [0..3]
                pos2 = pos.add(directions[k])

                if map.onMap(pos2) and
                not TERRAIN_TYPES[map.tiles[pos2.i][pos2.j]].block
                    unitAt = @ui.chapter.getUnitAt(pos2)
                    alt = posDist + 1

                    if (unitAt is null or
                    unitAt.team is @ui.chapter.enemyTeam) and
                    alt < dist[pos2.i][pos2.j] and
                    alt <= unit.move
                        dist[pos2.i][pos2.j] = alt
                        prev[pos2.i][pos2.j] = pos
                        dest = new Destination(pos2, [pos2])

                        prevPos = pos
                        while prevPos isnt null
                            dest.path.unshift(prevPos)
                            prevPos = prev[prevPos.i][prevPos.j]

                        available.push(dest)

        return available

class window.PlayerTurn extends Turn

    select: (@selectedUnit) ->
        @available = @getAvailable(@selectedUnit)

        for spot in @available
            @ui.chapter.map.setOverlay(spot.pos, 'available')

        @dest = new Destination()
        @updateDestination()

    deselect: ->
        @selectedUnit = null
        @dest = null
        @ui.chapter.map.clearOverlay()

    updateDestination: ->
        cp = @ui.cursor.pos
        if @ui.chapter.map.overlayTiles[cp.i][cp.j] is
        window.OVERLAY_TYPES['available']
            @dest.pos = cp.clone()

            for spot in @available
                if spot.pos.equals(cp)
                    @dest.path = spot.path
                    break


class Destination

    constructor: (@pos, @path) ->

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
                        while prevPos is not null
                            dest.path.unshift(prevPos)
                            prevPos = prev[prevPos.i][prevPos.j]

                        available.push(dest)

        return available

class window.PlayerTurn extends Turn

    select: (@selectedUnit) ->
        @available = @getAvailable(@selectedUnit)

        for spot in @available
            @ui.chapter.map.setOverlay(spot.pos, 'available')

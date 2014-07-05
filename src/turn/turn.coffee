getRandomPermutation = (k) ->
    todo = [0..k-1]
    perm = []

    while todo.length != 0
        r = Math.random()

        for i in [0..todo.length-1]
            if r < (i+1)/todo.length
                perm.push(todo.splice(i, 1)[0])
                break

    return perm

window._turn = {}

class _turn.Turn

    constructor: (@ui) ->
        @directions = [new Position(-1, 0), new Position(1, 0)
        new Position(0, -1), new Position(0, 1)]

    getAvailable: (unit) ->
        map = @ui.chapter.map
        available = [new _turn.Destination(unit.pos, [unit.pos])]

        queue = []
        queuePerm = getRandomPermutation(map.width*map.height)

        dist = Array(map.height)
        prev = Array(map.height)

        k = 0
        for i in [0..map.height-1]
            dist[i] = Array(map.width)
            prev[i] = Array(map.width)

            for j in [0..map.width-1]
                dist[i][j] = Infinity
                prev[i][j] = null
                queue[queuePerm[k]] = new Position(i, j)
                k++

        dist[unit.pos.i][unit.pos.j] = 0

        popClosest = ->
            minDist = Infinity

            for pos2, k in queue
                alt = dist[pos2.i][pos2.j]
                if alt < minDist
                    minDist = alt
                    minDistK = k

            return [queue.splice(minDistK, 1)[0], minDist]

        while queue.length != 0
            [pos, posDist] = popClosest()
            if posDist is Infinity
                break

            perm = getRandomPermutation(@directions.length)
            for k in perm
                pos2 = pos.add(@directions[k])
                unitAt = @ui.chapter.getUnitAt(pos2)

                if map.onMap(pos2) and
                not map.tiles[pos2.i][pos2.j].block
                    alt = posDist + 1

                    if (unitAt is null or unitAt.team is unit.team) and
                    alt < dist[pos2.i][pos2.j] and
                    alt <= unit.move
                        dist[pos2.i][pos2.j] = alt
                        prev[pos2.i][pos2.j] = pos
                        dest = new _turn.Destination(pos2, [pos2])

                        prevPos = pos
                        while prevPos isnt null
                            dest.path.unshift(prevPos)
                            prevPos = prev[prevPos.i][prevPos.j]

                        available.push(dest)

        return available

    getDirections: (totalRange) ->
        dirs = []

        for range in totalRange.array
            for di in [-range..range]
                for dj in [-range..range]
                    if Math.abs(di) + Math.abs(dj) == range
                        dirs.push(new Position(di, dj))

        return dirs

    getAttackRange: (unit, pos) ->
        attackRange = []

        for dir in @getDirections(unit.totalRange)
            alt = pos.add(dir)
            if @ui.chapter.map.onMap(alt)
                attackRange.push({moveSpot: pos, targetSpot: alt})

        return attackRange

    getActionRange: (pos, range) ->
        actionRange = []
        
        for dir in @getDirections(range)
            alt = pos.add(dir)
            if @ui.chapter.map.onMap(alt)
                actionRange.push(alt)

        return actionRange

    movementGetAttackRange: (available, unit=@selectedUnit) ->
        attackRange = []
        for avail in available
            localRange = @getAttackRange(unit, avail.pos)
            for obj in localRange
                obj.path = avail.path
                attackRange.push(obj)

        return attackRange

    afterBattle: =>
        toAdd = @battle.getExpToAdd()
        playerUnit = @battle.getPlayerUnit()
        increment = null

        callback = =>
            increment = playerUnit.addExp(toAdd)
            
            if increment is null
                @afterExpAdd()
            else
                @ui.levelUpWindow.init(playerUnit,
                    increment, callback2)

        callback2 = =>
            playerUnit.doIncrement(increment)
            @afterExpAdd()

        @ui.expBar.init(playerUnit, toAdd, callback)

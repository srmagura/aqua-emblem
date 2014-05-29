#I'm not sure if this is working
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

class window.Turn

    constructor: (@ui) ->
        @directions = [new Position(-1, 0), new Position(1, 0)
        new Position(0, -1), new Position(0, 1)]

    getAvailable: (unit) ->
        map = @ui.chapter.map
        available = [new Destination(unit.pos, [unit.pos])]

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
                        dest = new Destination(pos2, [pos2])

                        prevPos = pos
                        while prevPos isnt null
                            dest.path.unshift(prevPos)
                            prevPos = prev[prevPos.i][prevPos.j]

                        available.push(dest)

        return available

    getAttackDirections: (totalRange) ->
        dirs = []

        for range in totalRange
            for di in [-range..range]
                for dj in [-range..range]
                    if Math.abs(di) + Math.abs(dj) == range
                        dirs.push(new Position(di, dj))

        return dirs

    getAttackRange: (unit, pos) ->
        attackRange = []

        for dir in @getAttackDirections(unit.totalRange)
            alt = pos.add(dir)
            if @ui.chapter.map.onMap(alt)
                attackRange.push({moveSpot: pos, targetSpot: alt})

        return attackRange

    movementGetAttackRange: (available, unit=@selectedUnit) ->
        attackRange = []
        for avail in available
            localRange = @getAttackRange(unit, avail.pos)
            for obj in localRange
                obj.path = avail.path
                attackRange.push(obj)

        return attackRange

class window.PlayerTurn extends Turn

    select: (@selectedUnit) ->
        @available = @getAvailable(@selectedUnit)
        attackRange = @movementGetAttackRange(@available)

        for spot in attackRange
            @ui.chapter.map.setOverlay(spot.targetSpot, 'ATTACK')

        for spot in @available
            @ui.chapter.map.setOverlay(spot.pos, 'AVAILABLE')

        @dest = new Destination()
        @updateDestination()

    deselect: ->
        @selectedUnit = null
        @dest = null
        @ui.chapter.map.clearOverlay()

    updateDestination: ->
        cp = @ui.cursor.pos
        if @ui.chapter.map.overlayTiles[cp.i][cp.j] is
        OVERLAY_TYPES.AVAILABLE
            @dest.pos = cp.clone()

            for spot in @available
                if spot.pos.equals(cp)
                    @dest.path = spot.path
                    break

    initMove: ->
        unitAtDest = @ui.chapter.getUnitAt(@dest.pos)
        if unitAtDest isnt null and unitAtDest isnt @selectedUnit
            return

        @selectedUnit.oldPos = @selectedUnit.pos
        @ui.chapter.map.clearOverlay()
        @ui.cursor.visible = false
        @ui.controlState = new ControlState(@ui)

        @selectedUnit.followPath(@dest.path, @afterPathFollow)
        @dest = null

    afterPathFollow: =>
        @ui.unitInfoBox.populate(@selectedUnit)
        @ui.unitInfoBox.show()

        attackRange = @getAttackRange(@selectedUnit, @selectedUnit.pos)
        @inRange = []

        for obj in attackRange
            @ui.chapter.map.setOverlay(obj.targetSpot, 'ATTACK')
            target = @ui.chapter.getUnitAt(obj.targetSpot)
            if target? and target.team isnt @selectedUnit.team
                @inRange.push(target)

        actions = []

        if @inRange.length != 0
            actions.push(new ActionMenuItem('Attack', @handleAttack))

        actions.push(new ActionMenuItem('Wait', @handleWait))
        @ui.actionMenu.init(actions)

    handleWait: =>
        @ui.cursor.visible = true
        @selectedUnit.setDone()
        @deselect()

    handleAttack: =>
        @ui.cursor.visible = true
        @ui.cursor.moveTo(@inRange[0].pos)

        @ui.actionMenu.hide()
        @ui.controlState = new CsChooseTarget(@ui, this)

    afterBattle: =>
        @ui.controlState = new CsMap(@ui)
        @ui.cursor.visible = true
        @ui.cursor.moveTo(@selectedUnit.pos)

        @selectedUnit.setDone()
        @selectedUnit = null

class window.Destination

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



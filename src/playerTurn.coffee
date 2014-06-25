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
        @inAttackRange = []

        for obj in attackRange
            @ui.chapter.map.setOverlay(obj.targetSpot, 'ATTACK')
            target = @ui.chapter.getUnitAt(obj.targetSpot)
            if target? and target.team isnt @selectedUnit.team
                @inAttackRange.push(target)

        @inTradeRange = []
        for pos in @getActionRange(@selectedUnit, [1])
            target = @ui.chapter.getUnitAt(pos)
            if target? and target.team is @selectedUnit.team
                @inTradeRange.push(target)

        actions = []

        if @inAttackRange.length != 0
            actions.push(new ActionMenuItem('Attack', @handleAttack))

        actions.push(new ActionMenuItem('Skill', @handleSkill))
            
        if @inTradeRange.length != 0
            actions.push(new ActionMenuItem('Trade', @handleTrade))

        actions.push(new ActionMenuItem('Wait', @handleWait))
        @ui.actionMenu.init(actions)

    handleWait: =>
        @ui.cursor.visible = true
        @selectedUnit.setDone()
        @deselect()

    handleAttack: =>
        @ui.actionMenu.hide()
        @ui.weaponMenu.init(this)

    handleSkill: =>
        @ui.skillsBox.init(@selectedUnit, @skillsBoxOnD)

    skillsBoxOnD: =>

    handleTrade: =>
        @ui.controlState = new CsChooseTradeTarget(@ui, this)
        @ui.cursor.visible = true
        @ui.cursor.moveTo(@inTradeRange[0].pos)

    afterExpAdd: =>
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
            ctx.moveTo(@path[k].j*tw + tw/2 - ui.origin.j,
            @path[k].i*tw + tw/2 - ui.origin.i)
            ctx.lineTo(@path[k+1].j*tw + tw/2 - ui.origin.j,
            @path[k+1].i*tw + tw/2 - ui.origin.i)
            k++

        if k > 0
            s = 10
            x0 = @pos.j*tw - ui.origin.j
            y0 = @pos.i*tw - ui.origin.i

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



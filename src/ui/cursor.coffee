class window.Cursor

    constructor: (@ui) ->
        @visible = false

    moveTo: (pos) ->
        #console.log(pos)
        @pos = pos.clone()
        @ui.controlState.moved()
        @ui.chapter.playerTurn.updateDestination()
        @ui.unitInfoBox.update()

    move: (di, dj) ->
        newPos = @pos.add(new Position(di, dj))
        newPosPx = newPos.scale(@ui.tw)

        c = @ui.canvas
        if newPosPx.j >= c.width() + @ui.origin.j or
        newPosPx.j < @ui.origin.j
            @ui.origin.j += dj*@ui.tw

        if newPosPx.i >= c.height() + @ui.origin.i or
        newPosPx.i < @ui.origin.i
            @ui.origin.i += di*@ui.tw

        @moveTo(newPos)

    render: (ui, ctx) ->
        return if not @visible or not @pos?

        s = 5
        tw = ui.tw

        ctx.strokeStyle = 'purple'
        ctx.beginPath()
        ctx.rect(@pos.j*tw + s - ui.origin.j,
        @pos.i*tw + s - ui.origin.i,
        tw - 2*s, tw - 2*s)
        ctx.stroke()

window.AI_TYPE = {
    NORMAL: 0,
    HALT: 1
}

class window.Team
    
    constructor: (@units, attr={}) ->
        for unit in @units
            unit.team = this

            if attr.isAi and 'aiType' not of unit
                unit.aiType = AI_TYPE.NORMAL

            if 'defaultName' of attr and not unit.name?
                unit.name = attr.defaultName

class window.Unit

    constructor: (attr) ->
        @rawStats = {}

        for stat, value of @baseStats
            if stat of @growthRates
                value += @growthRates[stat] * (attr['level']-1)

            @rawStats[stat] = value
            this[stat] = Math.round(value)

        for key, value of attr
            this[key] = value

        if 'lord' not of this
            @lord = false

        if 'picture' not of this
            @picture = false

        if 'inventory' not of this
            @inventory = []

        for item in @inventory
            if item.itemType is ITEM_TYPE.WEAPON
                @equipped = item
                break

        @offset = new Position(0, 0)

    setDone: ->
        @done = true
        @ui.chapter.checkAllDone()

    followPath: (@path, @pathFollowCallback) ->
        @pathNext()

    pathNext: ->
        @offset = new Position(0, 0)
        @pos = @path.shift().clone()

        if @path.length != 0
            @direction = @path[0].subtract(@pos)
        else
            @direction = null
            @pathFollowCallback()

    calcCombatStats: ->
        if not @equipped? or @equipped.weight <= @con
            @attackSpeed = @speed
        else
            @attackSpeed = @speed - @equipped.weight + @con

        if @equipped?
            @hit = @equipped.hit + 2*@skill + @luck / 2
            @atk = @str + @equipped.might
            @crit = @equipped.crit + @skill / 2

        @evade = @attackSpeed*2 + @luck
        @critEvade = @luck

    render: (ui, ctx) ->
        tw = ui.tw

        if @done
            ctx.fillStyle = 'gray'
        else if @team is ui.chapter.playerTeam
            ctx.fillStyle = 'blue'
        else
            ctx.fillStyle = 'red'


        ctx.beginPath()
        offset = @pos.scale(tw).add(@offset)
        ctx.arc(offset.j + tw/2, offset.i + tw/2,
            .2*tw, 0, 2*Math.PI, false)
        ctx.fill()


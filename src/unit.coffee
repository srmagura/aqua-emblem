class window.Team
    
    constructor: (@units) ->
        for unit in @units
            unit.setTeam(this)

class window.PlayerTeam extends Team
    constructor: (@units, attr={}) ->
        for unit in @units
            if 'skills' not of unit
                unit.skills = []

            unit.skills = [new _skill.Defend()].concat(unit.skills)

        super(@units)


window.AI_TYPE = {
    NORMAL: 0,
    HALT: 1
}

class window.EnemyTeam extends Team
    constructor: (@units, attr={}) ->
        for unit in @units
            if 'aiType' not of unit
                unit.aiType = AI_TYPE.NORMAL

            if 'defaultName' of attr and not unit.name?
                unit.setName(attr.defaultName)

        super(@units)

class window.Unit

    @INVENTORY_SIZE: 5

    constructor: (attr) ->
        for key, value of attr
            this[key] = value

        if @name?
            @setName(@name)

        @calcStats()

        if 'picture' not of this
            @picture = false
        if 'boss' not of this
            @boss = false
        if 'exp' not of this
            @exp = 0
        if 'inventory' not of this
            @inventory = []

        @refreshInventory()
        @statuses = []

        @offset = new Position(0, 0)

    setInventory: (i, item) ->
        @inventory[i] = item
        @refreshInventory()

    deleteItem: (i) ->
        @inventory.splice(i, 1)
        @refreshInventory()

    refreshInventory: ->
        @totalRange = []
        for item in @inventory
            if @canWield(item)
                if not @equipped?
                    @equipped = item

                for range in item.range
                    if range not in @totalRange
                        @totalRange.push(range)

    onNewTurn: ->
        toRemove = []

        for status, i in @statuses
            status.turns--

            if status.turns == 0
                toRemove.push(i)

        for i in toRemove
            @statuses.splice(i, 1)

    hasStatus: (cls) ->
        for status in @statuses
            if status instanceof cls
                return true

        return false

    canUseSkill: (skl) ->
        return @mp >= skl.mp

    setName: (@name) ->
        @id = @name.toLowerCase().replace(' ', '-')

    fillInBaseStats: (baseStats) ->
        if not @baseStats?
            @baseStats = {}

        for stat, value of baseStats
            if stat not of @baseStats
                @baseStats[stat] = value

    calcStats: (dryRun=false) ->
        increment = {}

        for stat, value of @baseStats
            if stat of @growthRates
                value += @growthRates[stat] * (@level-1)

            rounded = Math.round(value)

            if rounded > this[stat]
                increment[stat] = 1

            if not dryRun
                this[stat] = rounded

        return increment

    addExp: (toAdd) ->
        newExp = @exp + toAdd

        if newExp >= 1
            @exp = newExp - 1
            @level++
            return @calcStats(true)
        else
            @exp = newExp
            return null

    doIncrement: (increment) ->
        for stat in increment
            this[stat]++

    canUse: (item) ->
        return @canWield(item)

    canWield: (item) ->
        if not (item instanceof _item.Weapon)
            return false

        for cls in @wield
            if item instanceof cls
                return true

        return false

    setTeam: (@team) ->
        prefix = 'images/dango/'
        filename = @uclassName.toLowerCase() + '.png'

        if @team instanceof PlayerTeam
            dir = 'player/'
        else
            dir = 'enemy/'

        @imageObjects = {}
        @imageObjects.normal = new Image()
        @imageObjects.normal.src = prefix + dir + filename

        @imageObjects.done = new Image()
        @imageObjects.done.src = prefix + 'done/' + filename

        if @boss
            @imageObjects.crown = new Image()
            @imageObjects.crown.src = 'images/crown.png'

    setDone: ->
        @done = true
        @ui.chapter.checkAllDone()

    followPath: (@path, @pathFollowCallback) ->
        @followingPath = true
        @pathNext()

    pathNext: ->
        @offset = new Position(0, 0)
        @pos = @path.shift().clone()

        if @path.length != 0
            @direction = @path[0].subtract(@pos)
            @movementSpeed = .4
        else
            @direction = null
            @followingPath = false
            @pathFollowCallback()

    calcCombatStats: ->
        if not @equipped?
            @attackSpeed = @speed
        else
            @attackSpeed = @speed - @equipped.weight + 5

            if @attackSpeed < 0
                @attackSpeed = 0

        if @equipped?
            @hit = @equipped.hit + 2*@skill + @luck / 2
            @atk = @str + @equipped.might
            @crit = @equipped.crit + @skill / 2

        @evade = @attackSpeed*2 + @luck
        @critEvade = @luck

    render: (ui, ctx) ->
        if @done
            image = @imageObjects.done
        else
            image = @imageObjects.normal

        offset = @pos.scale(@ui.tw).add(@offset).subtract(ui.origin)
        ctx.drawImage(image, offset.j+1, offset.i+2)

        if @boss
            ctx.drawImage(@imageObjects.crown,
            offset.j+12, offset.i+3)

        if @statuses.length != 0
            ctx.beginPath()
            s = 28
            ctx.arc(offset.j + s, offset.i + s,
            4, 0, 2 * Math.PI, false)
            ctx.fillStyle = 'orange'
            ctx.strokeStyle = '#440000'
            ctx.stroke()
            ctx.fill()
            
    getImagePath: ->
        return 'images/characters/' + @name.toLowerCase() + '.png'

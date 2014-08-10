window._unit = {}

_unit.aiType = {
    normal: 0,
    halt: 1,
    aggressive: 2
}

_unit.LUNGE_STATUS = {
    NOT_LUNGING: 0,
    FORWARD: 1,
    REVERSE: 2
}

class _unit.Unit

    constructor: (attr) ->
        for key, value of attr
            this[key] = value

        if @name?
            @setName(@name)

        @baseStats = {}
        @statuses = []

        @calcStatsInitial()
        
        if 'picture' not of this
            @picture = false
        if 'boss' not of this
            @boss = false
        if 'exp' not of this
            @exp = 0
        if 'items' not of this
            @items = []

        @inventory = new _unit.Inventory(this, @items)
        delete @items

        @lungeStatus = _unit.LUNGE_STATUS.NOT_LUNGING
        @offset = new Position(0, 0)

    onNewTurn: ->
        while true
            toRemove = null

            for status, i in @statuses
                if not status.newTurn()
                    toRemove = i
                    break

            if toRemove?
                @statuses.splice(toRemove, 1)
            else
                break

        @updateStats()

    addStatus: (status) ->
        doAdd = true
        toRemove = []

        for other, i in @statuses
            if other instanceof _status.Buff and
            other.stat == status.stat
                if other.value > status.value
                    doAdd = false
                else
                    toRemove.push(i)

        for i in toRemove
            @statuses.splice(i, 1)

        if doAdd
            @statuses.push(status)

        @updateStats()

    hasStatus: (cls) ->
        for status in @statuses
            if status instanceof cls
                return true

        return false

    canUseSkill: (skl) ->
        return @mp >= skl.mp

    setName: (@name) ->
        @id = @name.toLowerCase().replace(' ', '-')
        
    setEquipped: (item) -> @inventory.setEquipped(item)

    fillInStartStats: (startStats) ->
        if not @startStats?
            @startStats = {}

        for stat, value of startStats
            if stat not of @startStats
                @startStats[stat] = value

    calcStatsInitial: ->
        @calcStats()

        @hp = @maxHp
        if @maxMp?
            @mp = Math.round(@maxMp/2)
            
        @statuses = []
        @done = false

    calcStats: (dryRun=false) ->
        increment = {}

        for stat, value of @startStats
            if stat of @growthRates
                value += @growthRates[stat] * (@level-1)

            rounded = Math.round(value)

            if rounded > @baseStats[stat]
                increment[stat] = 1

            if not dryRun
                @baseStats[stat] = rounded
                @updateStat(stat)
                
        if @allSkills?
            @skills = []
            for obj in @allSkills
                if @level >= obj.level
                    @skills.push(obj.skill)
                if @level == obj.level
                    increment.newSkill = obj.skill

        return increment

    updateStats: ->
        for stat of @baseStats
            @updateStat(stat)

    updateStat: (stat) ->
        value = @baseStats[stat]
        for status in @statuses
            if status instanceof _status.Buff and
            status.stat == stat
                value += status.value

        this[stat] = value

    addHp: (toAdd) ->
        newHp = @hp + toAdd

        if newHp > @maxHp
            @hp = @maxHp
        else
            @hp = newHp

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
        for stat of increment
            @baseStats[stat]++

        @updateStats()

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

        if @team instanceof _team.PlayerTeam
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
        if not @ui?
            return
    
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
        else
            @hit = null
            @atk = null
            @crit = null

        terrain = @ui.chapter.map.getTerrain(@pos)

        @evade = @attackSpeed*2 + @luck + terrain.evade
        @critEvade = @luck
        @defResBonus = terrain.def

    updateLunge: =>
        if @lungeStatus is _unit.LUNGE_STATUS.NOT_LUNGING
            return

        dist = @offset.norm()

        if @lungeStatus is _unit.LUNGE_STATUS.FORWARD and dist > 11
            @direction = @direction.scale(-1)
            @lungeStatus++
        else if @lungeStatus is _unit.LUNGE_STATUS.REVERSE and
        @direction.dot(@offset) > 0
            @direction = null
            @offset = new Position(0, 0)
            @lungeStatus = 0          

    render: (ui, ctx) ->
        if @done
            image = @imageObjects.done
        else
            image = @imageObjects.normal

        offset = @pos.scale(ui.tw).add(@offset).subtract(ui.origin)
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
        
    pickle: ->
        {
            constructor: _util.getFunctionName(@constructor),
            level: @level,
            exp: @exp,
            inventory: @inventory.pickle()
        }
        
    @unpickle: (pickled) ->   
        if pickled.constructor of _unit.special
            constructor = _unit.special[pickled.constructor]
            unit = new constructor()
        else
            return null
            
        if 'level' of pickled
            unit.level = pickled.level
        else
            return null
            
        if 'exp' of pickled
            unit.exp = pickled.exp
        else
            return null
          
        unit.inventory = _unit.Inventory.unpickle(pickled.inventory, unit)
        if not unit.inventory?
            return null
            
        return unit

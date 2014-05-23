class window.Team
    
    constructor: (@units) ->
        for unit in @units
            unit.team = this

        #if(teamId == TEAM_ENEMY && !('aiType' in this.units[k])){
        #    this.units[k].aiType = AI_NORMAL
        #}

#@AI_NORMAL: 0
#@AI_HALT: 1

class window.Unit

    constructor: (attr) ->
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

    render: (ui, ctx) ->
        tw = ui.tw

        if @team is ui.chapter.playerTeam
            ctx.fillStyle = 'blue'
        else
            ctx.fillStyle = 'red'

        ctx.beginPath()
        offset = @pos.scale(tw).add(@offset)
        ctx.arc(offset.j + tw/2, offset.i + tw/2,
            .2*tw, 0, 2*Math.PI, false)
        ctx.fill()

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

###
    this.die = function(){
        for(var k = 0; k < units.length; k++){
            if(units[k].id == this.id){
                units.splice(k, 1)
            }
        }

        var team
        if(this.team == TEAM_PLAYER)
            team = chapter.playerTeam
        else if(this.team == TEAM_ENEMY)
            team = chapter.enemyTeam

        for(var k = 0; k < team.units.length; k++){
            if(team.units[k].id == this.id){
                team.units.splice(k, 1)
            }
        }

        if(this.lord){
            chapter.defeat()
            return false
        } else {
            updateUnitInfoBox()
            return !chapter.checkConditions()
        }
    }

    this.setDone = function(){
        this.done = true
        chapter.checkAllDone()
    }

    if(!('inventory' in this)){
        this.inventory = []
    }

    this.equipped = null
    for(var k = 0; k < this.inventory.length; k++){
        if(this.inventory[k].itemType == IT_WEAPON){
            this.equipped = this.inventory[k]
        }
    }

    this.direction = null
    this.offset = [0, 0]

}

function Item(itemId){
    for(var key in allItems[itemId]){
        this[key] = allItems[itemId][key]
    }

    this.itemId = itemId
}

IT_WEAPON = 0
WT_SWORD = 0
var allItems = {
    'iron-sword': {itemType: IT_WEAPON, 
    weaponType: WT_SWORD, 
    name: 'Iron sword', might: 4} 
}
###

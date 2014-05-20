#AI_NORMAL = 0
#AI_HALT = 1

class window.Team
    
    constructor: (@units) ->
        for unit in @units
            @unit.team = this

        #if(teamId == TEAM_ENEMY && !('aiType' in this.units[k])){
        #    this.units[k].aiType = AI_NORMAL
        #}

###
function Unit(attr){
    this.followPath = function(path, callback){
        this.path = path
        this.pathFollowCallback = callback
        this.pathNext()
    }

    this.pathNext = function(){
        this.offset = [0, 0]
        this.pos = $.extend({}, this.path.shift())

        if(this.path.length != 0){
            this.direction = posSubtract(this.path[0], this.pos)
        } else {
            this.direction = null
            this.pathFollowCallback()
        }
    }

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

    for(var key in attr){
        this[key] = attr[key]
    }

    if(!('lord' in this)){
        this.lord = false
    }

    if(!('picture' in this)){
        this.picture = false
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

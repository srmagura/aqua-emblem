var TEAM_PLAYER = 0
var TEAM_ENEMY = 1

var AI_NORMAL = 0
var AI_HALT = 1

function Team(units, teamId){
    this.id = teamId
    this.units = units

    for(var k = 0; k < this.units.length; k++){
        this.units[k].id = teamId + '-' + k
        this.units[k].team = teamId

        if(teamId == TEAM_ENEMY && !('aiType' in this.units[k])){
            this.units[k].aiType = AI_NORMAL
        }
    }
}

var units = []

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

    this.direction = null
    this.offset = [0, 0]

}

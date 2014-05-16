var TEAM_PLAYER = 0
var TEAM_ENEMY = 1

function Team(units, teamId){
    this.id = teamId
    this.units = units

    for(var k = 0; k < this.units.length; k++){
        this.units[k].id = teamId + '-' + k
        this.units[k].team = teamId

        if(!('lord' in this.units[k])){
            this.units.lord = false
        }
    }
}

var units = []

function Unit(attr){
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
}

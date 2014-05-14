var TEAM_PLAYER = 0
var TEAM_ENEMY = 1

function Team(units, teamId){
    this.id = teamId
    this.units = units

    for(var k = 0; k < this.units.length; k++){
        this.units[k].id = teamId + '-' + k
        this.units[k].team = teamId
    }
}

var units = []

function unitDeath(unit){
    for(var k = 0; k < units.length; k++){
        if(units[k].id == unit.id){
            units.splice(k, 1)
        }
    }
}

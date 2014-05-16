var VC_ROUT = 0
var victoryConditionText = {}
victoryConditionText[VC_ROUT] = "Defeat all enemies"

function Chapter(map1, playerTeam, enemyTeam, victoryCondition){
    this.initUnits = function(){
        units = []
        for(var k = 0; k < this.playerTeam.units.length; k++){
            this.playerTeam.units[k].pos = this.map.playerPositions[k]
            units.push(playerTeam.units[k])
        }

        for(var k = 0; k < this.enemyTeam.units.length; k++){
            units.push(this.enemyTeam.units[k])
        }

        for(var k = 0; k < units.length; k++){
            units[k].hp = units[k].baseHp
        }
    }

    this.checkConditions = function(){
        var victory = false

        if(this.victoryCondition == VC_ROUT){
            var allDefeated = true
            for(var k = 0; k < units.length; k++){
                if(units[k].team == TEAM_ENEMY)
                    allDefeated = false
            }

            victory = allDefeated
        }

        if(victory){
            showVictoryMessage()
            updateUnitInfoBox()
            /*cursorPos = [0, 0]
            cursorMoved()
            initChapter()*/
        }

        if(victory){
            this.done = true
            return true
        } else {
            return false
        }
    }

    this.defeat = function(){
        this.done = true
        showDefeatMessage()
        hideUnitInfoBox()
    }

    this.initTurn = function(team){
        var callback = function(teamId){
            if(teamId == TEAM_ENEMY){
                controlState = ControlState
                doEnemyTurn()
            } else {
                controlState = csMap
                cursorVisible = true
            }
        }

        for(var k = 0; k < units.length; k++){
            units[k].done = false
        }

        controlState = ControlState
        if(team == this.enemyTeam){
            cursorVisible = false
        }

        showPhaseMessage(team.id, callback)
    }

    this.checkAllDone = function(){
        var allDone = true
        for(var k = 0; k < this.playerTeam.units.length; k++){
            if(!this.playerTeam.units[k].done){
                allDone = false
            }
        }

        if(allDone){
            this.initTurn(this.enemyTeam)
        }
    }

    this.map = map1
    map = map1

    this.playerTeam = playerTeam
    this.enemyTeam = enemyTeam

    this.done = false
    this.victoryCondition = victoryCondition
    $('.victory-condition').text(
        victoryConditionText[victoryCondition])

    this.initUnits()
    this.initTurn(playerTeam)
}

function posEquals(pos1, pos2){
    return pos1[0] == pos2[0] && pos1[1] == pos2[1]
}

function posAdd(pos1, pos2){
    return [pos1[0] + pos2[0], pos1[1] + pos2[1]]
}

/*function getDist(pos1, pos2){
    return Math.abs(pos1[0]-pos2[0]) + Math.abs(pos1[1]-pos2[1])
}*/

function onMap(pos){
    return (0 <= pos[0] && pos[0] < map.height &&
        0 <= pos[1] && pos[1] < map.width)
}

function getUnitAt(pos){
    for(var k = 0; k < units.length; k++){
        if(posEquals(units[k].pos, pos)){
            return units[k]
        }
    }

    return null
}

function Map(tiles, playerPositions){
    this.clearOverlay = function(){
        for(var i = 0; i < this.height; i++){
            for(var j = 0; j < this.width; j++){
                this.overlayTiles[i][j] = 0
            }
        }
    }

    this.tiles = tiles
    this.playerPositions = playerPositions
    this.height = this.tiles.length
    this.width = this.tiles[0].length

    this.overlayTiles = []
    for(var i = 0; i < this.height; i++){
        this.overlayTiles.push([])
        for(var j = 0; j < this.width; j++){
            this.overlayTiles[i].push(0) 
        }
    }
}

var terrainTypes = {
    0: {color: '#BFB', block: false},
    1: {color: '#DDD', block: true}
}

var OVERLAY_AVAILABLE = 1
var OVERLAY_ATTACK = 2

var overlayTileTypes = {
    1: {startColor: '#AAF', endColor: '#22F'},
    2: {startColor: '#FAA', endColor: '#F22'}
}

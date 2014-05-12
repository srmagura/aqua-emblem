requestAnimationFrame = window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.msRequestAnimationFrame || window.mozRequestAnimationFrame;

var then
var ctx

var tw = 35
var nTiles = 12
var canvasWidth = tw*nTiles

var map
var gridStyle = '#666'
var gridWidth = 2

var cursorPos = [0, 0]
var selectedUnit = null
var destination = null

var csPrototype = {
    up: function(){},
    down: function(){},
    left: function(){},
    right: function(){},
    f: function(){},
    d: function(){}
}

var directions = [[-1, 0], [1, 0], [0, -1], [0, 1]]

function movementSearch(unit){
    var queue = []
    var dist = Array(map.height)

    for(var i = 0; i < map.height; i++){
        dist[i] = Array(map.width)
        for(var j = 0; j < map.width; j++){
            dist[i][j] = Infinity
            queue.push([i, j])
        }
    }

    dist[unit.pos[0]][unit.pos[1]] = 0
    map.overlayTiles[unit.pos[0]][unit.pos[1]] = 1

    function popClosest(){
        var minDist = Infinity
        var minDistK = -1

        for(var k = 0; k < queue.length; k++){
            var alt = dist[queue[k][0]][queue[k][1]]
            if(alt < minDist){
                minDist = alt
                minDistK = k
            }
        }

        return [queue.splice(minDistK, 1)[0], minDist]
    }

    while(queue.length > 0){
        var rv = popClosest()
        var pos1 = rv[0]
        var pos1Dist = rv[1]
        if(pos1Dist == Infinity){
            break
        }

        for(var k = 0; k < directions.length; k++){
            var pos2 = posAdd(pos1, directions[k]) 

            if(onMap(pos2) &&
                map.overlayTiles[pos2[0]][pos2[1]] == 0 &&
                !terrainTypes[map.tiles[pos2[0]][pos2[1]]].block){
                var unitAt = getUnitAt(pos2)
                var alt = pos1Dist + 1

                if((unitAt == null || unitAt.team != TEAM_ENEMY) &&
                    alt < dist[pos2[0]][pos2[1]]){
                    dist[pos2[0]][pos2[1]] = alt

                    if(alt <= unit.move)
                        map.overlayTiles[pos2[0]][pos2[1]] = 1
                }
            }
        }
    }
}

function selectUnit(unit){
    selectedUnit = unit
    movementSearch(unit)
    updateDestination()
}

function deselect(){
    selectedUnit = null 
    destination = null
    map.clearOverlay()
}

function updateDestination(){
    if(map.overlayTiles[cursorPos[0]][cursorPos[1]] ==
        OVERLAY_AVAILABLE){
        destination = $.extend({}, cursorPos)
    }
}

function cursorMoved(){
    updateUnitInfoBox()

    if(selectedUnit != null){
        updateDestination()
    }
}

function initMove(){
    selectedUnit.pos = $.extend({}, destination)
    destination = null
    $('.unit-info').css('visibility', 'hidden')

    var onWait = function(){
        deselect()
    }

    initActionMenu({"Wait": onWait});
}

var csMap = Object.create(csPrototype)
csMap.up = function(){
    if(cursorPos[0]-1 >= 0){
        cursorPos[0]--
        cursorMoved()
    }
}

csMap.down = function(){
    if(cursorPos[0]+1 < map.height){
        cursorPos[0]++
        cursorMoved()
    }
}

csMap.left = function(){
    if(cursorPos[1]-1 >= 0){
        cursorPos[1]--
        cursorMoved()
    }
}
    
csMap.right = function(){
    if(cursorPos[1]+1 < map.width){
        cursorPos[1]++
        cursorMoved()
    }
}

csMap.f = function(){
    if(selectedUnit == null){
        var unit = getUnitAt(cursorPos)
        if(unit != null && unit.team == TEAM_PLAYER){
            selectUnit(unit)
        }
    } else if(posEquals(destination, cursorPos)){
        initMove()
    }
}

csMap.d = function(){
    deselect()
}

var controlState = csMap

function keydownHandler(e){
    //console.log(e.which)
    switch(e.which){
        case 38:
            controlState.up()
            break
        case 40:
            controlState.down()
            break
        case 37:
            controlState.left()
            break
        case 39:
            controlState.right()
            break
        case 70:
            controlState.f()
            break
        case 68:
            controlState.d()
            break
    }

    if(37 <= e.which && e.which <= 40){
        e.preventDefault()
        return false
    }
}

function update(delta){
}

function mainLoop(){
    var now = Date.now()
    var delta = now - then
    requestAnimationFrame(mainLoop)

    update(delta / 1000);
    render();

    then = now
}

function init(){
    ctx = $('canvas')[0].getContext('2d')
    $(window).keydown(keydownHandler)

    map = new Map()
    initUnits()

    then = Date.now()
    mainLoop()
}

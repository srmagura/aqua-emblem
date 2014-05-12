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

function selectUnit(unit){
    selectedUnit = unit

    var i = unit.pos[0]
    var j = unit.pos[1]

    for(var di = -unit.move; di <= unit.move; di++){
        for(var dj = -unit.move + Math.abs(di); 
            dj <= unit.move - Math.abs(di); dj++){

            if(onMap([i+di, j+dj]) &&
                !terrainTypes[map.tiles[i+di][j+dj]].block){
                map.overlayTiles[i+di][j+dj] = 1
            }
        }
    }

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

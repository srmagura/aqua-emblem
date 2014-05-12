var w = window;
requestAnimationFrame = w.requestAnimationFrame || w.webkitRequestAnimationFrame || w.msRequestAnimationFrame || w.mozRequestAnimationFrame;

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
}

function deselect(){
    selectedUnit = null 
    destination = null
    map.clearOverlay()
}

function updateUnitInfoBox(){
    var cursorUnit = getUnitAt(cursorPos)
    if(cursorUnit == null){
        $('.unit-info').css('visibility', 'hidden')
    } else {
        $('.unit-info').css('visibility', 'visible').
            html(cursorUnit.name)
    }
}

function cursorMoved(){
    updateUnitInfoBox()

    if(selectedUnit != null){
        if(!posEquals(selectedUnit.pos, cursorPos) &&
            map.overlayTiles[cursorPos[0]][cursorPos[1]] ==
            OVERLAY_AVAILABLE){
            destination = $.extend({}, cursorPos)
        }
    }
}

var csMap = {
    up: function(){
        if(cursorPos[0]-1 >= 0){
            cursorPos[0]--
            cursorMoved()
        }
    },
    down: function(){
        if(cursorPos[0]+1 < map.height){
            cursorPos[0]++
            cursorMoved()
        }
    },
    left: function(){
        if(cursorPos[1]-1 >= 0){
            cursorPos[1]--
            cursorMoved()
        }
    },
    right: function(){
        if(cursorPos[1]+1 < map.width){
            cursorPos[1]++
            cursorMoved()
        }
    },
    f: function(){
        if(selectedUnit == null){
            var unit = getUnitAt(cursorPos)
            if(unit != null){
                selectUnit(unit)
            }
        } else {
            if(posEquals(destination, cursorPos)){
                selectedUnit.pos = $.extend({}, destination)
                deselect()
                updateUnitInfoBox()
            }
        }
    },
    d: function(){
        deselect()
    }
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
    map = new Map()
    for(var k = 0; k < units.length; k++){
        units[k].pos = map.playerPositions[k];
    }

    $(window).keydown(keydownHandler)
    then = Date.now()
    ctx = $('canvas')[0].getContext('2d')
    mainLoop()
}

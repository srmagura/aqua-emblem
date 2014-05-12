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

function onMap(pos){
    return (0 <= pos[0] && pos[0] < map.height &&
        0 <= pos[1] && pos[1] < map.width)
}

function selectUnit(unit){
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

var csMap = {
    up: function(){
        if(cursorPos[0]-1 >= 0)
            cursorPos[0]--
    },
    down: function(){
        if(cursorPos[0]+1 < map.height)
            cursorPos[0]++
    },
    left: function(){
        if(cursorPos[1]-1 >= 0)
            cursorPos[1]--
    },
    right: function(){
        if(cursorPos[1]+1 < map.width)
            cursorPos[1]++
    },
    f: function(){
        var unit = getUnitAt(cursorPos)
        if(unit != null){
            selectUnit(unit)
        }
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

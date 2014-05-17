requestAnimationFrame = window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.msRequestAnimationFrame || window.mozRequestAnimationFrame;

var then
var ctx

var maxNTiles = 12
var canvas

var cursorVisible = false
var cursorPos = [0, 0]

var selectedUnit = null
var destination = null

var ControlState = {
    up: function(){},
    down: function(){},
    left: function(){},
    right: function(){},
    f: function(){},
    d: function(){}
}

var controlState = ControlState

var directions = [[-1, 0], [1, 0], [0, -1], [0, 1]]
var enemiesInRange
var battle

var map
var chapter


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

MOVEMENT_SPEED = 400 

function update(delta){
    for(var k = 0; k < units.length; k++){
        if(units[k].direction != null){
            if(Math.abs(units[k].offset[0]) >= tw ||
                Math.abs(units[k].offset[1]) >= tw){
                units[k].pathNext()
            } else {
                units[k].offset = posAdd(units[k].offset,
                    posScale(units[k].direction, 
                    delta * MOVEMENT_SPEED))
            }
        }
    }
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
    canvas = $('canvas')
    ctx = canvas[0].getContext('2d')
    $(window).keydown(keydownHandler)

    initChapter()

    canvas.attr('width', map.width*tw)
    canvas.attr('height', map.height*tw)
    $('.wrapper').css('width', canvas.width() + 
        $('.left-sidebar').width()*2 + 30)
    $('.game-wrapper').css('height', canvas.height() + 40)

    then = Date.now()
    mainLoop()
}

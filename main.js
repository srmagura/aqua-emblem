requestAnimationFrame = window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.msRequestAnimationFrame || window.mozRequestAnimationFrame;

var then
var ctx

var maxNTiles = 12
var canvas

var cursorVisible = true
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
    canvas = $('canvas')
    ctx = canvas[0].getContext('2d')
    $(window).keydown(keydownHandler)

    initChapter()

    canvas.attr('width', map.width*tw)
    canvas.attr('height', map.height*tw)
    $('.game-wrapper').css('width', canvas.width() + 
        $('.left-sidebar').width()*2 + 30)

    then = Date.now()
    mainLoop()
}

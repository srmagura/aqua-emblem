var tw = 35

var gridStyle = '#666'
var gridWidth = 2

function renderMap(){
    ctx.fillStyle = 'white'
    ctx.fillRect(0, 0, canvas.width(), canvas.width())

    for(var i = 0; i < map.height; i++){
        for(var j = 0; j < map.width; j++){
            var x0 = j*tw
            var y0 = i*tw

            ctx.fillStyle = terrainTypes[map.tiles[i][j]].color
            ctx.fillRect(x0, y0, tw, tw)

            var overlayTile = map.overlayTiles[i][j]
            if(overlayTile != 0){
                ctx.beginPath()
                ctx.rect(x0, y0, tw, tw)

                var tileType = overlayTileTypes[overlayTile]

                var grd = ctx.createLinearGradient(
                    x0, y0, x0+tw, y0+tw);
                grd.addColorStop(0, tileType.startColor);   
                grd.addColorStop(1, tileType.endColor);
                ctx.fillStyle = grd;
                ctx.globalAlpha = .7
                ctx.fill()
                ctx.globalAlpha = 1
            }
        }
    }
}

function renderGrid(){
    ctx.lineWidth = gridWidth
    ctx.strokeStyle = gridStyle

    var offset
    
    //horizontal
    for(var i = 0; i < map.height + 1; i++){
        offset = 0
        if(i == 0){
            var offset = gridWidth / 2
        }

        ctx.beginPath()
        ctx.moveTo(offset, i*tw + offset)
        ctx.lineTo(map.width*tw + offset, i*tw + offset)
        ctx.stroke()
    }

    //vertical
    for(var j = 0; j < map.width + 1; j++){
        offset = 0
        if(j == 0){
            var offset = gridWidth / 2
        }
        ctx.beginPath()
        ctx.moveTo(j*tw + offset, offset)
        ctx.lineTo(j*tw + offset, map.height*tw + offset)
        ctx.stroke()
    }
}

function renderDestination(){
    if(destination == null || destination.pos == null)
        return

    var x0
    var y0
    var x1
    var y1
    var k

    ctx.beginPath()
    for(k = 0; k < destination.path.length - 1; k++)
    {
        x0 = destination.path[k][1]*tw + tw/2
        y0 = destination.path[k][0]*tw + tw/2
        x1 = destination.path[k+1][1]*tw + tw/2
        y1 = destination.path[k+1][0]*tw + tw/2

        ctx.moveTo(x0, y0)
        ctx.lineTo(x1, y1)
    }


    var s = 10
    x0 = destination.pos[1]*tw
    y0 = destination.pos[0]*tw

    if(k > 0){
        var direction = posSubtract(destination.pos, destination.path[k-1])

        if(posEquals(direction, [1, 0])){
            ctx.moveTo(x0+s, y0+s)
            ctx.lineTo(x0+tw/2, y0 + tw/2)
            ctx.lineTo(x0+tw-s, y0+s)
        } else if(posEquals(direction, [-1, 0])){
            ctx.moveTo(x0+s, y0+tw-s)
            ctx.lineTo(x0+tw/2, y0 + tw/2)
            ctx.lineTo(x0+tw-s, y0+tw-s)
        } else if(posEquals(direction, [0, 1])){
            ctx.moveTo(x0+s, y0+s)
            ctx.lineTo(x0+tw/2, y0 + tw/2)
            ctx.lineTo(x0+s, y0+tw-s)
        } else if(posEquals(direction, [0, -1])){
            ctx.moveTo(x0+tw-s, y0+s)
            ctx.lineTo(x0+tw/2, y0 + tw/2)
            ctx.lineTo(x0+tw-s, y0+tw-s)
        }

        ctx.strokeStyle = '#2266FF'
        ctx.lineWidth = 7
        ctx.stroke()

        ctx.strokeStyle = '#3399FF'
        ctx.lineWidth = 3
        ctx.stroke()

        ctx.strokeStyle = '#5BF'
        ctx.lineWidth = 1
        ctx.stroke()

        ctx.lineWidth = 2
    }
}


function renderUnits(){
    for(var k = 0; k < units.length; k++){
        ctx.beginPath()

        if(units[k].done){
            ctx.fillStyle = 'gray'
        } else {
            switch(units[k].team){
                case TEAM_PLAYER:
                    ctx.fillStyle = 'blue'
                    break
                case TEAM_ENEMY:
                    ctx.fillStyle = 'red'
                    break
            }
        }

        var pos = units[k].pos
        var offsetPos = posAdd(units[k].offset, posScale(pos, tw)) 
        ctx.arc(tw/2 + offsetPos[1], tw/2 + offsetPos[0], .2*tw, 0,
            2*Math.PI, false)
        ctx.fill()
    }
}

function renderCursor(){
    if(!cursorVisible)
        return

    var s = 5
    ctx.strokeStyle = 'purple'
    ctx.beginPath()
    ctx.rect(cursorPos[1]*tw + s, cursorPos[0]*tw + s, tw - 2*s, tw - 2*s)
    ctx.stroke()
}

function render(){
    renderMap()
    renderGrid()
    renderDestination()
    renderUnits()
    renderCursor()
}

function posEquals(pos1, pos2){
    return pos1[0] == pos2[0] && pos1[1] == pos2[1]
}

function getUnitAt(pos){
    for(var k = 0; k < units.length; k++){
        if(posEquals(units[k].pos, pos)){
            return units[k]
        }
    }

    return null
}

function Map(){
    this.tiles = [
        [1,1,0,0,0],
        [1,0,0,0,0],
        [0,0,0,0,0],
        [0,0,0,0,1],
        [0,0,0,0,1]
    ]
    this.playerPositions = [[2,1]]
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

var overlayTileTypes = {
    1: {startColor: '#8ED6FF', endColor: '#004CB3'}
}

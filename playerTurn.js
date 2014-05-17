function movementGetAvailable(unit){
    var available = [unit.pos]

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
                        available.push(pos2)
                }
            }
        }
    }

    return available
}

function selectUnit(unit){
    selectedUnit = unit
    var available = movementGetAvailable(unit)
    for(var k = 0; k < available.length; k++){
        var pos = available[k]
        map.overlayTiles[pos[0]][pos[1]] = 1
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

function handleWait(){
    cursorVisible = true
    selectedUnit.setDone()
    deselect()
}


function handleAttack(){
    for(var id in enemiesInRange){
        cursorVisible = true
        cursorPos = $.extend({}, enemiesInRange[id].pos)
        break
    }
    cursorMoved()

    $('.action-menu').css('display', 'none')
    controlState = csChooseTarget
}

function initMove(){
    var unitAtDest = getUnitAt(destination)
    if(unitAtDest != null && unitAtDest.id != selectedUnit.id)
        return

    selectedUnit.oldPos = selectedUnit.pos
    selectedUnit.pos = $.extend({}, destination)
    updateUnitInfoBox()

    destination = null
    map.clearOverlay()

    var attackRange = []
    for(var k = 0; k < directions.length; k++){
        var alt = posAdd(selectedUnit.pos, directions[k])
        if(onMap(alt)){
            attackRange.push(alt)
        }
    }

    enemiesInRange = {}
    for(var k = 0; k < attackRange.length; k++){
        map.overlayTiles[attackRange[k][0]]
            [attackRange[k][1]] = OVERLAY_ATTACK 
        
        var unit = getUnitAt(attackRange[k])
        if(unit != null && unit.team == TEAM_ENEMY){
            enemiesInRange[unit.id] = unit
        }
    }

    var actions = []
    if(!$.isEmptyObject(enemiesInRange)){
        actions.push({name: "Attack", handler: handleAttack})
    }

    actions.push({name: "Wait", handler: handleWait})

    initActionMenu(actions);
}

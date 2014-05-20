function getRandomPermutation(k){
    var todo = []
    for(var l = 0; l < k; l++){
        todo.push(l)
    }

    var perm = []
    while(todo.length != 0){
        var r = Math.random()

        for(var l = 0; l < todo.length; l++){
            if(r < (l + 1)/todo.length){
                perm.push(todo.splice(l, 1)[0])
                break
            }
        }
    }

    return perm
}

function movementGetAvailable(unit){
    var available = [{pos: unit.pos, path: [unit.pos]}]

    var queue = []
    var dist = Array(map.height)
    var prev = Array(map.height)

    for(var i = 0; i < map.height; i++){
        dist[i] = Array(map.width)
        prev[i] = Array(map.width)
        for(var j = 0; j < map.width; j++){
            dist[i][j] = Infinity
            prev[i][j] = null
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

        var perm = getRandomPermutation(directions.length)
        for(var k = 0; k < directions.length; k++){
            var pos2 = posAdd(pos1, directions[perm[k]]) 

            if(onMap(pos2) &&
                map.overlayTiles[pos2[0]][pos2[1]] == 0 &&
                !terrainTypes[map.tiles[pos2[0]][pos2[1]]].block){
                var unitAt = getUnitAt(pos2)
                var alt = pos1Dist + 1

                if((unitAt == null || unitAt.team != TEAM_ENEMY) &&
                    alt < dist[pos2[0]][pos2[1]]){

                    if(alt <= unit.move){
                        dist[pos2[0]][pos2[1]] = alt
                        prev[pos2[0]][pos2[1]] = pos1

                        var obj = {pos: pos2, path: [pos2]}

                        var prevPos = pos1
                        while(prevPos != null){
                            obj.path.unshift(prevPos)
                            prevPos = prev[prevPos[0]][prevPos[1]]
                        }

                        available.push(obj)
                    }
                }
            }
        }
    }

    return available
}

function getAttackRange(moveSpot){
    var attackRange = []

    for(var k = 0; k < directions.length; k++){
        var alt = posAdd(moveSpot.pos, directions[k])
        if(onMap(alt)){
            attackRange.push({moveSpot: moveSpot, targetSpot: alt})
        }
    }

    return attackRange
}

function movementGetAttackRange(available){
    var attackRange = []

    for(var k = 0; k < available.length; k++){
        attackRange = attackRange.concat(
            getAttackRange(available[k]))
    }

    return attackRange
}

function Destination(){
    this.pos = null
    this.path = []
}

function selectUnit(unit){
    selectedUnit = unit
    unit.spotsAvailable = movementGetAvailable(unit)
    for(var k = 0; k < unit.spotsAvailable.length; k++){
        var pos = unit.spotsAvailable[k].pos
        map.overlayTiles[pos[0]][pos[1]] = 1
    }

    destination = new Destination()
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
        destination.pos = $.extend({}, cursorPos)

        var sa = selectedUnit.spotsAvailable
        for(var k = 0; k < sa.length; k++){
            if(posEquals(sa[k].pos, cursorPos)){
                destination.path = sa[k].path
                break
            }
        }
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
    var unitAtDest = getUnitAt(destination.pos)
    if(unitAtDest != null && unitAtDest.id != selectedUnit.id)
        return

    selectedUnit.oldPos = selectedUnit.pos

    map.clearOverlay()
    cursorVisible = false
    controlState = ControlState

    selectedUnit.followPath(
        destination.path,
        afterPathFollow)
    destination = null
}

function afterPathFollow(){
    updateUnitInfoBox()

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
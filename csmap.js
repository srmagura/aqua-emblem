var csMap = Object.create(ControlState)
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

csChooseTarget = Object.create(csMap)

csChooseTarget.f = function(){
    target = getUnitAt(cursorPos)

    if(target != null && target.id in enemiesInRange){
        battle = new Battle(selectedUnit, target)
        initWeaponMenu()
        initBattleStatsPanel()
    }
}

csChooseTarget.d = function(){
    showActionMenu()
    controlState = csActionMenu
    cursorPos = $.extend({}, selectedUnit.pos)
    cursorMoved()
}

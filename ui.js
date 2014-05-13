function updateUnitInfoBox(){
    var cursorUnit = getUnitAt(cursorPos)
    if(cursorUnit == null){
        hideUnitInfoBox()
    } else {
        showUnitInfoBox()

        $('.unit-info .name').text(cursorUnit.name)
        $('.unit-info .hp').text(cursorUnit.hp)
        $('.unit-info .base-hp').text(cursorUnit.baseHp)

        switch(cursorUnit.team){
            case TEAM_PLAYER:
                $('.unit-info').removeClass('red-box').
                    addClass('blue-box')
                break
            case TEAM_ENEMY:
                $('.unit-info').removeClass('blue-box').
                    addClass('red-box')
                break
        }
    }
}

function showUnitInfoBox(){
    $('.unit-info').css('visibility', 'visible')
}

function hideUnitInfoBox(){
    $('.unit-info').css('visibility', 'hidden')
}

var actionMenuItems

function initActionMenu(actions){
    actionMenuItems = actions
    $('.action-menu').html('')

    for(var k = 0; k < actions.length; k++){
        var menuItem = $(document.createElement('div'))
        menuItem.data('index', k).
            appendTo('.action-menu').text(actions[k].name)
    }

    $('.action-menu div').first().toggleClass('selected')
    showActionMenu()
    controlState = csActionMenu
}

function showActionMenu(){
    $('.action-menu').css('display', 'inline-block')
}

function hideActionMenu(){
    $('.action-menu').css('display', 'none')
}

var csMenu = Object.create(ControlState)

csMenu.up = function(){
    var selected = $('.' + this.menuClass + ' .selected')

    if(selected.prev().size() != 0){
        selected.prev().addClass('selected')
        selected.removeClass('selected')
    }
}

csMenu.down = function(){
    var selected = $('.' + this.menuClass + ' .selected')

    if(selected.next().size() != 0){
        selected.next().addClass('selected')
        selected.removeClass('selected')
    }
}

var csActionMenu = Object.create(csMenu)
csActionMenu.menuClass = 'action-menu'

csActionMenu.f = function(){
    var k = $('.action-menu .selected').data('index')
    hideActionMenu()
    controlState = csMap

    actionMenuItems[k].handler() 
}

csActionMenu.d = function(){
    hideActionMenu()
    controlState = csMap

    selectedUnit.pos = selectedUnit.oldPos 
    cursorPos = $.extend({}, selectedUnit.pos)
    deselect()
}

function initWeaponMenu(){
    var menuItem = $(document.createElement('div'))
    menuItem.addClass('selected').text('Plastic sword').
        appendTo('.weapon-menu')
    showWeaponMenu()
    controlState = csWeaponMenu
}

function showWeaponMenu(){
    $('.weapon-menu').css('display', 'inline-block')
}

function hideWeaponMenu(){
    $('.weapon-menu').css('display', 'none')
}

var csWeaponMenu = Object.create(csMenu)
csWeaponMenu.menuClass = 'weapon-menu'

function initBattleStatsPanel(){
    $('.battle-stats-panel .attacker-name').
        text(battle.attacker.name)
    $('.battle-stats-panel .attacker-hit').
        text(battle.attackerBattleStats.hit)
    $('.battle-stats-panel .attacker-dmg').
        text(battle.attackerBattleStats.dmg)

    $('.battle-stats-panel .defender-name').
        text(battle.defender.name)
    $('.battle-stats-panel .defender-hit').
        text(battle.defenderBattleStats.hit)
    $('.battle-stats-panel .defender-dmg').
        text(battle.defenderBattleStats.dmg)
    showBattleStatsPanel()
}

function showBattleStatsPanel(){
    $('.battle-stats-panel').css('display', 'inline-block')
}

function hideBattleStatsPanel(){
    $('.battle-stats-panel').css('display', 'none')
}

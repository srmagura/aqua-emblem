function updateUnitInfoBox(){
    var cursorUnit = getUnitAt(cursorPos)
    if(cursorUnit == null){
        $('.unit-info').css('visibility', 'hidden')
    } else {
        $('.unit-info').css('visibility', 'visible').
            html(cursorUnit.name)
    }
}

var actionMenuItems

function initActionMenu(actions){
    actionMenuItems = actions

    for(name in actions){
        var menuItem = $(document.createElement('div'))
        menuItem.appendTo('.action-menu').text(name)
    }

    $('.action-menu div').first().toggleClass('selected')
    $('.action-menu').css('visibility', 'visible')
    controlState = csActionMenu
}

var csActionMenu = Object.create(csPrototype)
csActionMenu.f = function(){
    var actionName = $('.action-menu .selected').text()
    $('.action-menu').html('').css('visibility', 'hidden')
    controlState = csMap

    actionMenuItems[actionName]() 
}

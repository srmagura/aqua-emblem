function initUnitInfoWindow(unit){
    $('.dark-overlay').show()

    var w = $('.unit-info-window')
    var dw = $(document).width()
    w.css({visibility: 'visible', left: (dw-w.width())/2, top: 40})

    w.find('.common img').attr('src', 'images/' + 
        unit.name.toLowerCase() + '.png')

    var nameField = unit.name
    if(unit.lord){
        nameField += ' <div class="lord">(Lord)</div>'
    }

    w.find('.common .name').html(nameField)
    w.find('.common .uclass').text('Mercenary')
    w.find('.common .level').text('1')
    w.find('.common .exp').text('0')

    w.find('.tab-label-inventory').addClass('selected')
    var inv = w.find('.tab-content-inventory').show().html('')

    for(var k = 0; k < unit.inventory.length; k++){
        var item = unit.inventory[k]
        var row = $('<div>' + item.name + '</div>')
        inv.append(row)
    }

    var stats = w.find('.tab-content-stats')
    var statTypes = ['str', 'skill', 'mag', 'speed', 'def', 'luck',
        'res', 'move', 'aid', 'con']

    for(var k = 0; k < statTypes.length; k++){
        var st = statTypes[k]
        stats.find('.' + st).text(unit[st])
    }

    controlState = csUnitInfoWindow
}

function closeUnitInfoWindow(){
    $('.dark-overlay').hide()
    $('.unit-info-window').css('visibility', 'hidden')
    controlState = csMap
}

function unitInfoWindowChangeTab(tabId){
    var labels = $('.tab-container .labels')
    var oldTabId = labels.find('.selected').removeClass('selected').
        find('.tab-id').text()
    $('.tab-container .tab-content-' + oldTabId).hide()

    labels.find('.tab-label-' + tabId).addClass('selected')
    $('.tab-container .tab-content-' + tabId).show()
}

var csUnitInfoWindow = Object.create(controlState)

csUnitInfoWindow.d = function(){
    closeUnitInfoWindow()    
}

csUnitInfoWindow.left = function(){
    var selectedLabel = $('.tab-container .labels .selected')
    var tabId 
    var label

    if(selectedLabel.prev().size() == 0){
        label = selectedLabel.siblings().last()
    } else {
        label = selectedLabel.prev()
    }

    tabId = label.find('.tab-id').text()
    unitInfoWindowChangeTab(tabId)
}

csUnitInfoWindow.right = function(){
    var selectedLabel = $('.tab-container .labels .selected')
    var tabId 
    var label

    if(selectedLabel.next().size() == 0){
        label = selectedLabel.siblings().first()
    } else {
        label = selectedLabel.next()
    }

    tabId = label.find('.tab-id').text()
    unitInfoWindowChangeTab(tabId)
}

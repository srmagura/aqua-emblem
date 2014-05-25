class window.UnitInfoWindow

    constructor: (@ui) ->
        @window = $('.unit-info-window')

    init: (unit) ->
        $('.dark-overlay').show()

        w = @window
        w.removeClass('blue-box').removeClass('red-box')

        if unit.team is @ui.chapter.playerTeam
            w.addClass('blue-box')
        else
            w.addClass('red-box')

        docWidth = $(document).width()
        w.css({visibility: 'visible',
        left: (docWidth-w.width())/2, top: 40})

        if unit.picture
            w.find('.common .image-wrapper').removeClass('insignia')
            w.find('.common img').attr('src', 'images/' +
                unit.name.toLowerCase() + '.png')
        else if unit.team.insigniaImagePath?
            w.find('.common .image-wrapper').addClass('insignia')
            w.find('.common img').attr('src',
                unit.team.insigniaImagePath)

        nameField = unit.name
        if unit.lord
            nameField += ' <div class="lord">(Lord)</div>'

        w.find('.common .name').html(nameField)
        w.find('.common .uclass').text(unit.uclassName)
        w.find('.common .level').text(unit.level)
        w.find('.common .exp').text('0')

        w.find('.labels > div').removeClass('selected')
        w.find('.tab-content').hide()

        w.find('.tab-label-inventory').addClass('selected')
        inv = w.find('.tab-content-inventory').show().html('')

        for item in unit.inventory
            row = $('<div>' + item.name + '</div>')
            inv.append(row)

        stats = w.find('.tab-content-stats')
        statTypes = ['str', 'skill', 'mag', 'speed', 'def', 'luck',
            'res', 'move', 'aid', 'con']

        for st in statTypes
            stats.find('.' + st).text(unit[st])

        @ui.controlState = new CsUnitInfoWindow(@ui, this)

    hide: ->
        $('.dark-overlay').hide()
        @window.css('visibility', 'hidden')
        @ui.controlState = new CsMap(@ui)

    changeTab: (tabId) ->
        labels = @window.find('.tab-container .labels')
        oldTabId = labels.find('.selected').removeClass('selected').
            find('.tab-id').text()
        @window.find('.tab-container .tab-content-' + oldTabId).hide()

        labels.find('.tab-label-' + tabId).addClass('selected')
        @window.find('.tab-container .tab-content-' + tabId).show()

class CsUnitInfoWindow extends ControlState

    constructor: (@ui, @windowObj) ->

    d: ->
        @windowObj.hide()

    left: ->
        selectedLabel = @windowObj.window.
            find('.tab-container .labels .selected')

        if selectedLabel.prev().size() == 0
            label = selectedLabel.siblings().last()
        else
            label = selectedLabel.prev()

        tabId = label.find('.tab-id').text()
        @windowObj.changeTab(tabId)

    right: ->
        selectedLabel = @windowObj.window.
            find('.tab-container .labels .selected')

        if selectedLabel.next().size() == 0
            label = selectedLabel.siblings().first()
        else
            label = selectedLabel.next()

        tabId = label.find('.tab-id').text()
        @windowObj.changeTab(tabId)

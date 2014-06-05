class window.UnitInfoWindow

    constructor: (@ui) ->
        @window = $('.unit-info-window')

    init: (@unit) ->
        @initCommon()
        @initInventoryTab()
        @initStatsTab()
        @ui.controlState = new CsUnitInfoWindow(@ui, this)

    initCommon: ->
        $('.dark-overlay').show()

        w = @window
        w.removeClass('blue-box').removeClass('red-box')

        if @unit.team is @ui.chapter.playerTeam
            w.addClass('blue-box')
        else
            w.addClass('red-box')

        docWidth = $(document).width()
        w.css({visibility: 'visible',
        left: (docWidth-w.width())/2})

        if @unit.picture
            w.find('.common .image-wrapper').removeClass('insignia')
            w.find('.common img').attr('src',
            'images/characters/' + @unit.name.toLowerCase() + '.png')
        else if @unit.team.insigniaImagePath?
            w.find('.common .image-wrapper').addClass('insignia')
            w.find('.common img').attr('src',
                @unit.team.insigniaImagePath)

        w.find('.common .name').html(@unit.name)
        w.find('.common .uclass').text(@unit.uclassName)
        w.find('.common .level').text(@unit.level)
        w.find('.common .exp').text('0')

        w.find('.labels > div').removeClass('selected')
        w.find('.tab-content').hide()

    initInventoryTab: ->
        w = @window
        w.find('.tab-label-inventory').addClass('selected')
        invContent = w.find('.tab-content-inventory').show()
        inv = invContent.find('.inventory').html('')

        for item in @unit.inventory
            inv.append(item.getElement())

        @unit.calcCombatStats()
        combatStats = invContent.find('.combat-stats')
        combatStatsStr = {hit: @unit.hit,
        crit: @unit.crit, evade: @unit.evade, atk: @unit.atk}

        for key, value of combatStatsStr
            if not value?
                value = '--'
            else
                value = Math.round(value)

            combatStats.find('.' + key).text(value)

    initStatsTab: ->
        stats = @window.find('.tab-content-stats')
        statTypes = ['str', 'skill', 'mag', 'speed', 'def', 'luck',
            'res', 'move']

        for st in statTypes
            stats.find('.' + st).text(@unit[st])

        weaponsEl = stats.find('.weapons').html('')
        for weaponClass in @unit.wield
            $('<div><img src="images/items/' +
            (new weaponClass()).image + '" /></div>').appendTo(weaponsEl)


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

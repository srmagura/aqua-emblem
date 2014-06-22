class window.ViewportOverlay

    constructor: (@ui) ->
        @overlay = $('.viewport-overlay')

    show: ->
        @overlay.show()

    hide: ->
        @overlay.hide()


class window.UnitInfoWindow

    constructor: (@ui) ->
        @window = $('.unit-info-window')

    init: (@unit) ->
        @initCommon()
        @initInventoryTab()
        @initStatsTab()

        if @unit.skills?
            @initSkillsTab()

        @prevControlState = @ui.controlState
        @ui.controlState = new CsUnitInfoWindow(@ui, this)

        css = @ui.centerElement(@window, 4)
        css.visibility = 'visible'
        @window.css(css)

    initCommon: ->
        @ui.viewportOverlay.show()

        w = @window
        w.removeClass('blue-box').removeClass('red-box')

        if @unit.team is @ui.chapter.playerTeam
            w.addClass('blue-box')
        else
            w.addClass('red-box')

        if @unit.picture
            w.find('.common .image-wrapper').removeClass('insignia')
            w.find('.common img').attr('src', @unit.getImagePath())
        else if @unit.team.insigniaImagePath?
            w.find('.common .image-wrapper').addClass('insignia')
            w.find('.common img').attr('src',
                @unit.team.insigniaImagePath)

        w.find('.common .name').html(@unit.name)
        w.find('.common .uclass').text(@unit.uclassName)
        w.find('.common .level').text(@unit.level)
        w.find('.common .exp').text(Math.floor(@unit.exp*100))

        w.find('.labels > div').removeClass('selected')
        w.find('.tab-content').hide()

    initInventoryTab: ->
        w = @window
        w.find('.tab-label-inventory').addClass('selected')
        invContent = w.find('.tab-content-inventory').show()
        inv = invContent.find('.inventory').html('')

        for item in @unit.inventory
            inv.append(item.getElement(@unit.canUse(item)))

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

    initSkillsTab: ->
        @window.find('.tab-container .labels').
            append($('.invisible .tab-label-skills'))

        tab = $('.invisible .tab-content-skills')
        @window.find('.tab-container .content').append(tab)

        skillsDiv = tab.find('.skills')
        skillsDiv.html('')

        for skl in @unit.skills
            div = $('<div></div>').addClass('skill').
                appendTo(skillsDiv)
            img = $('<img />').attr('src', skl.getImagePath()).
                appendTo(div)

    hide: ->
        @window.find('.tab-label-skills, .tab-content-skills').
            removeClass('selected').attr('style', '').appendTo('.invisible')

        @ui.viewportOverlay.hide()
        @window.css('visibility', 'hidden')

    changeTab: (tabId) ->
        labels = @window.find('.tab-container .labels')
        oldTabId = labels.find('.selected').removeClass('selected').
            find('.tab-id').text()
        @window.find('.tab-container .tab-content-' + oldTabId).hide()

        labels.find('.tab-label-' + tabId).addClass('selected')
        @window.find('.tab-container .tab-content-' + tabId).show()

class CsWindow extends ControlState

    constructor: (@ui, @windowObj) ->

    d: ->
        @windowObj.hide()
        @ui.controlState = @windowObj.prevControlState


class CsUnitInfoWindow extends CsWindow

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

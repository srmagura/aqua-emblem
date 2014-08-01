class _cui.ViewportOverlay

    constructor: (@ui) ->
        @overlay = $('.viewport-overlay')

    show: ->
        @overlay.show()

    hide: ->
        @overlay.hide()

class _cui.UnitInfoWindow

    constructor: (@ui) ->
        @window = $('.unit-info-window')

        skillInfoBoxEl = $('.canvas-container .skill-info-box')
        @skillInfoBox = new _cui.SkillInfoBox(@ui, skillInfoBoxEl)

        skillsEl = $('.invisible .tab-content-skills .skills-box')
        @skillsBox = new _cui.SkillsBox(@ui, skillsEl, @skillInfoBox)

        itemInfoBoxEl = $('.sidebar .item-info-box').clone()
        $('.canvas-container').append(itemInfoBoxEl)
        @itemInfoBox = new _cui.ItemInfoBox(@ui, itemInfoBoxEl)

    init: (@unit) ->
        @initCommon()
        @initInventoryTab()
        @initStatsTab()

        if @unit.skills?
            @initSkillsTab()

        @prevControlState = @ui.controlState
        @ui.controlState = new _cs.cui.UnitInfoWindow(@ui, this)

        css = @ui.centerElement(@window, 4)
        css.visibility = 'visible'
        @window.css(css)

        css = @window.position()
        css.left += @window.width() + 20
        @skillInfoBox.box.css(css)

        css.top += @window.find('.inventory').position().top + 3
        @itemInfoBox.box.css(css)

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

        for item in @unit.inventory.it()
            options = {
                usable: @unit.canUse(item)
                equipped: @unit.equipped is item
            }
        
            inv.append(item.getElement(options))

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
            td = stats.find('.' + st)
            td.text(@unit.baseStats[st])

            buff = $('<span></span>').addClass('buff')
            delta = @unit[st] - @unit.baseStats[st]
            if delta > 0
                buff.text('+' + delta)

            if delta != 0
                td.append(buff)

        weaponsEl = stats.find('.weapons').html('')
        for weaponClass in @unit.wield
            $('<div><img src="images/items/' +
            (new weaponClass()).image + '" /></div>').appendTo(weaponsEl)

    initSkillsTab: ->
        @window.find('.tab-container .labels').
            append($('.invisible .tab-label-skills'))

        tab = $('.invisible .tab-content-skills')
        @window.find('.tab-container .content').append(tab)

        @skillsBox.init(@unit, @skillsBoxOnD)

    skillsBoxOnD: =>
        @ui.controlState = new _cs.cui.UnitInfoWindow(@ui, this)

    hide: ->
        @window.find('.tab-label-skills, .tab-content-skills').
            removeClass('selected').attr('style', '').appendTo('.invisible')

        @ui.viewportOverlay.hide()
        @window.css('visibility', 'hidden')

    getSelectedLabel: ->
        return @window.find('.tab-container .labels .selected')

    changeTab: (tabId) ->
        labels = @window.find('.tab-container .labels')
        oldTabId = labels.find('.selected').removeClass('selected').
            find('.tab-id').text()
        @window.find('.tab-container .tab-content-' + oldTabId).hide()

        labels.find('.tab-label-' + tabId).addClass('selected')
        @window.find('.tab-container .tab-content-' + tabId).show()

    selectedItemChanged: ->
        selected = @window.find('.inventory .selected')
        item = selected.data('item')
        @itemInfoBox.init(item, @unit.canUse(item))


class _cs.cui.UnitInfoWindow extends _cs.cui.Chapter

    constructor: (@ui, @windowObj) ->

    d: ->
        @windowObj.hide()
        @ui.controlState = @windowObj.prevControlState

    s: ->
        sel = @windowObj.getSelectedLabel()
        if sel.hasClass('tab-label-skills')
            @windowObj.skillsBox.giveControl()

        else if sel.hasClass('tab-label-inventory')
            el = @windowObj.window.find('.inventory')
            @ui.controlState = new _cs.cui.UnitInfoWindowInventory(@ui, el)

            el.children().first().addClass('selected')
            @windowObj.selectedItemChanged()

    left: ->
        selectedLabel = @windowObj.getSelectedLabel()

        if selectedLabel.prev().size() == 0
            label = selectedLabel.siblings().last()
        else
            label = selectedLabel.prev()

        tabId = label.find('.tab-id').text()
        @windowObj.changeTab(tabId)

    right: ->
        selectedLabel = @windowObj.getSelectedLabel()

        if selectedLabel.next().size() == 0
            label = selectedLabel.siblings().first()
        else
            label = selectedLabel.next()

        tabId = label.find('.tab-id').text()
        @windowObj.changeTab(tabId)


class _cs.cui.UnitInfoWindowInventory extends _cs.cui.Menu

    constructor: (@ui, menu) ->
        super(@ui, {menu: menu})

    onChange: ->
        @ui.unitInfoWindow.selectedItemChanged()

    d: ->
        @menuObj.menu.find('.selected').removeClass('selected')
        @ui.unitInfoWindow.itemInfoBox.hide()
        @ui.controlState = new _cs.cui.UnitInfoWindow(@ui, @ui.unitInfoWindow)

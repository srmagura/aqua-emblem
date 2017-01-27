class _chapterui.WeaponMenu

    constructor: (@ui) ->
        @menu = $('.weapon-menu')
        
        itemInfoBoxEl = $('.sidebar .item-info-box')
        @itemInfoBox = new _chapterui.ItemInfoBox(@ui, itemInfoBoxEl)

    init: (playerTurn) ->
        if playerTurn?
            @playerTurn = playerTurn
            @unit = @playerTurn.selectedUnit
    
        @menu.html('')

        for item in @unit.inventory.it()
            if @unit.canWield(item)
                options = {equipped: item is @unit.equipped}
            
                menuItem = $('<div><div class="image"></div></div>')
                menuItem.addClass('menu-choice')
                menuItem.append(item.getElement(options))
                menuItem.appendTo(@menu)

        @menu.children('div').first().addClass('selected')
        @selectedItemChanged()

        @show()
        @ui.controlState = new _cs.chapterui.WeaponMenu(@ui, this)

    getSelectedItem: ->
        el = @menu.find('.selected .item-element')
        return el.data('item')

    selectedItemChanged: ->
        item = @getSelectedItem()
        @itemInfoBox.init(item, @unit.canUse(item))

    show: ->
        @menu.css('display', 'inline-block')

    hide: ->
        @itemInfoBox.hide()
        @menu.css('display', 'none')

class _cs.chapterui.WeaponMenu extends _cs.chapterui.Menu

    constructor: (@ui, @menuObj) ->
        @playerTurn = @ui.chapter.playerTurn

    onChange: ->
        @menuObj.selectedItemChanged()
    
    f: ->
        item = @menuObj.getSelectedItem()
        @menuObj.unit.setEquipped(item)
        @ui.weaponMenu.hide()

        pt = @menuObj.playerTurn
        @ui.controlState = new _cs.chapterui.ChooseAttackTarget(@ui, pt)
        @ui.cursor.moveTo(pt.inAttackRange[0].pos)
        @ui.cursor.visible = true

    d: ->
        @menuObj.hide()
        @ui.actionMenu.init()
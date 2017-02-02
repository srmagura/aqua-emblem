# Menu for selecting weapon to use in an encounter

class _chapterui.WeaponMenu

    constructor: (@ui) ->
        # Get access to the HTML elements we'll be needing
        @menu = $('.weapon-menu')

        itemInfoBoxEl = $('.sidebar .item-info-box')
        @itemInfoBox = new _chapterui.ItemInfoBox(@ui, itemInfoBoxEl)

    init: (playerTurn) ->
        # Populate and display the menu

        # Get the attacking unit
        if playerTurn?
            @playerTurn = playerTurn
            @unit = @playerTurn.selectedUnit

        # Clear previous contents
        @menu.html('')

        # Create a menu item for each weapon in the unit's inventory,
        # provided the unit can actually wield that weapon
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

        # set control state
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
        super(@ui, @menuObj)
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

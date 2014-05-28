class window.WeaponMenu

    constructor: (@ui) ->
        @menu = $('.weapon-menu')

    init: (@playerTurn) ->
        @ui.cursor.visible = false
        @menu.html('')

        for item in @playerTurn.selectedUnit.inventory
            if item instanceof window.item.Weapon
                menuItem = $('<div><div class="image"></div></div>')
                menuItem.append(item.getElement())
                menuItem.data('weapon', item).appendTo(@menu)

        @menu.children('div').first().addClass('selected')
        @show()
        @ui.controlState = new CsWeaponMenu(@ui, this)

    show: ->
        @menu.css('display', 'inline-block')

    hide: ->
        @menu.css('display', 'none')

class CsWeaponMenu extends CsMenu

    constructor: (@ui, @menuObj) ->
        @playerTurn = @ui.chapter.playerTurn

    onChange: ->
        @playerTurn.battle.setPlayerWeapon(@menuObj.menu.
            find('.selected').data('weapon'))
    
    f: ->
        @ui.unitInfoBox.hide()
        @ui.weaponMenu.hide()
        @ui.battleStatsPanel.hide()
        @ui.chapter.map.clearOverlay()
        @ui.cursor.visible = false
        @ui.controlState = new ControlState(@ui)

        @playerTurn.battle.doBattle(@playerTurn.afterBattle)

    d: ->
        @ui.cursor.visible = true
        @menuObj.hide()
        @ui.battleStatsPanel.hide()
        @ui.controlState = new CsChooseTarget(@ui, @menuObj.playerTurn)

class _cui.WeaponMenu

    constructor: (@ui) ->
        @menu = $('.weapon-menu')

    init: (@playerTurn) ->
        @menu.html('')
        unit = @playerTurn.selectedUnit

        for item in unit.inventory
            if unit.canWield(item)
                menuItem = $('<div><div class="image"></div></div>')
                menuItem.append(item.getElement())
                menuItem.data('weapon', item).appendTo(@menu)

        @menu.children('div').first().addClass('selected')
        @show()
        @ui.controlState = new _cs.WeaponMenu(@ui, this)

    show: ->
        @menu.css('display', 'inline-block')

    hide: ->
        @menu.css('display', 'none')

class _cs.WeaponMenu extends _cs.Menu

    constructor: (@ui, @menuObj) ->
        @playerTurn = @ui.chapter.playerTurn
    
    f: ->
        @ui.weaponMenu.hide()

        pt = @menuObj.playerTurn
        @ui.controlState = new _cs.ChooseAttackTarget(@ui, pt)
        @ui.cursor.moveTo(pt.inAttackRange[0].pos)
        @ui.cursor.visible = true

    d: ->
        @menuObj.hide()
        @ui.actionMenu.init()

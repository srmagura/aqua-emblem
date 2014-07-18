class _cui.ItemMenu

    constructor: (@ui) ->
        @menu = $('.item-menu')
        @actionMenu = new _cui.ItemActionMenu(@ui, this, 
            $('.item-action-menu'))
        @actionMenuConfirm = new _cui.ItemActionMenu(@ui, this,
            $('.item-action-menu-confirm'))
        
    init: (playerTurn) ->
        if playerTurn?
            @unit = playerTurn.selectedUnit
    
        @menu.html('')

        for item in @unit.inventory
             options = {
                usable: @unit.canUse(item),
                equipped: @unit.equipped is item
             }
             
            menuItem = $('<div><div class="image"></div></div>')
            menuItem.append(item.getElement(options))
            menuItem.appendTo(@menu)

        @menu.children('div').first().addClass('selected')

        @show()
        @menu.removeClass('in-submenu')
        @ui.controlState = new _cs.cui.ItemMenu(@ui, this)
        
    getSelectedItem: ->
        return @menu.find('.selected .item-container').data('item')
        
    handleDiscard: ->
        console.log 'handleDiscard'
        
    show: ->
        @menu.css('display', 'inline-block')

    hide: ->
        @menu.css('display', 'none')

        
class _cs.cui.ItemMenu extends _cs.cui.Menu

    constructor: (@ui, @menuObj) ->
    
    f: ->
        @menuObj.actionMenu.init()

    d: ->
        @menuObj.hide()
        @ui.actionMenu.init()
      
        
class _cui.ItemActionMenu extends _cui.ActionMenu

    constructor: (@ui, @itemMenu, @menu) ->
        super(@ui)
        
    init: ->
        item = @itemMenu.getSelectedItem()
        
        menuItems = []
        menuItems.push(new _cui.ActionMenuItem('Discard', @itemMenu.handleDiscard))
        super(menuItems)
        
        @itemMenu.menu.addClass('in-submenu')
        @ui.controlState = new _cs.cui.ItemActionMenu(@ui, this)
        
class _cs.cui.ItemActionMenu extends _cs.cui.Menu

    d: ->
        @menuObj.hide()
        @menuObj.itemMenu.init()
    

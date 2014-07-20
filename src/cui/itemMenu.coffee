class _cui.ItemMenu

    constructor: (@ui) ->
        @menu = $('.item-menu')
        @actionMenu = new _cui.ItemActionMenu(@ui, this, 
            $('.item-action-menu'))
        @actionMenuConfirm = new _cui.ItemActionMenuConfirm(@ui, this,
            $('.item-action-menu-confirm'))
        
    init: (playerTurn) ->
        if playerTurn?
            @playerTurn = playerTurn
            @unit = playerTurn.selectedUnit
    
        @menu.html('')

        i = 0
        for item in @unit.inventory.it()             
            menuItem = $('<div><div class="image"></div></div>')
            menuItem.data('index', i++)
            
            options = {
                usable: @unit.canUse(item),
                equipped: @unit.equipped is item
            }
            
            menuItem.append(item.getElement(options))
            menuItem.appendTo(@menu)

        @menu.children('div').first().addClass('selected')

        @show()
        @menu.removeClass('in-submenu')
        @ui.controlState = new _cs.cui.ItemMenu(@ui, this)
        
    getSelectedItem: ->
        return @menu.find('.selected .item-container').data('item')
        
    getSelectedIndex: ->
        return @menu.find('.selected').data('index')
        
    handleDiscard: =>
        @actionMenu.hide()
        @actionMenuConfirm.init()
        
    handleConfirmDiscard: =>
        @unit.inventory.remove(@getSelectedIndex())
        
        @actionMenuConfirm.hide()
        
        if @unit.inventory.size() != 0
            @init()
        else
            @hide()
            @playerTurn.initActionMenu()
        
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

    f: ->
        @menuObj.callSelectedHandler()

    d: ->
        @menuObj.hide()
        @menuObj.itemMenu.init()
        
        
class _cui.ItemActionMenuConfirm extends _cui.ActionMenu

    constructor: (@ui, @itemMenu, @container) ->
        super(@ui)
        @menu = @container.find('.menu')
        
    init: ->
        menuItems = [(new _cui.ActionMenuItem('Yes, discard', @itemMenu.handleConfirmDiscard))]
        super(menuItems)
        
        @ui.controlState = new _cs.cui.ItemActionMenuConfirm(@ui, this)
        
    show: ->
        super()
        @container.show()
        
    hide: ->
        super()
        @container.hide()
        
        
class _cs.cui.ItemActionMenuConfirm extends _cs.cui.Menu

    f: ->
        @menuObj.callSelectedHandler()
        
    d: ->
        @menuObj.hide()
        @menuObj.itemMenu.actionMenu.init()
        

    

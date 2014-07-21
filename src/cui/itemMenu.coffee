class _cui.ItemMenu

    constructor: (@ui) ->
        @container = $('.item-menu')
        @menu = @container.find('.menu-items')
        @actionMenu = new _cui.ItemActionMenu(@ui, this, 
            $('.item-action-menu'))
        @actionMenuConfirm = new _cui.ItemActionMenuConfirm(@ui, this,
            $('.item-action-menu-confirm'))
        
    init: (options={}) ->
        messageEl = @container.find('.message')
        messageEl.hide()
        
        selected = @menu.find('.selected')
        if selected.size() != 0
            cursorPos = selected.index()
        else
            cursorPos = 0
    
        if 'playerTurn' of options
            @playerTurn = options.playerTurn
            @unit = @playerTurn.selectedUnit
            @forceDiscard = false
            cursorPos = 0
            
        else if 'forceDiscard' of options and options.forceDiscard       
            @unit = options.unit
            @callback = options.callback
            @forceDiscard = true
            cursorPos = 0
            
        if @forceDiscard
            messageEl.text('Inventory full. Discard an item.').show()
            
        @menu.html('')

        i = 0
        for item in @unit.inventory.it()             
            menuItem = $('<div><div class="image"></div></div>')
            if i == cursorPos
                menuItem.addClass('selected')
            
            menuItem.data('index', i++)
            
            options = {
                usable: @unit.canUse(item),
                equipped: @unit.equipped is item
            }
            
            menuItem.append(item.getElement(options))
            menuItem.appendTo(@menu)

        @show()
        @menu.removeClass('in-submenu')
        @ui.controlState = new _cs.cui.ItemMenu(@ui, this)
        
    getSelectedItem: ->
        return @menu.find('.selected .item-element').data('item')
        
    getSelectedIndex: ->
        return @menu.find('.selected').data('index')
        
    handleEquip: =>
        @unit.setEquipped(@getSelectedItem())
        @actionMenu.hide()
        @ui.unitInfoBox.update()
        @init()
        
    handleDiscard: =>
        @actionMenu.hide()
        @actionMenuConfirm.init()
        
    handleConfirmDiscard: =>
        @unit.inventory.remove(@getSelectedIndex())
        @ui.unitInfoBox.update()
        
        @actionMenuConfirm.hide()
        
        if @forceDiscard
            @ui.controlState = new _cs.cui.Chapter(@ui)
            @hide()
            @callback()
        else
            if @unit.inventory.size() != 0
                @init()
            else
                @hide()
                @playerTurn.initActionMenu()                     
        
    show: ->
        @container.css('display', 'inline-block')

    hide: ->
        @container.css('display', 'none')

        
class _cs.cui.ItemMenu extends _cs.cui.Menu

    constructor: (@ui, @menuObj) ->
    
    f: ->
        @menuObj.actionMenu.init()

    d: ->
        if not @menuObj.forceDiscard
            @menuObj.hide()
            @ui.actionMenu.init()
      
        
class _cui.ItemActionMenu extends _cui.ActionMenu

    constructor: (@ui, @itemMenu, @menu) ->
        super(@ui)
        
    init: ->
        item = @itemMenu.getSelectedItem()
        
        menuItems = []
        
        if not @itemMenu.forceDiscard
            if @itemMenu.unit.canWield(item)
                menuItems.push(new _cui.ActionMenuItem('Equip',
                    @itemMenu.handleEquip))
        
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
        @menu = @container.find('.menu-items')
        
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
        

    

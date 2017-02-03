// Generated by CoffeeScript 1.8.0
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  _cui.ItemMenu = (function() {
    function ItemMenu(ui) {
      this.ui = ui;
      this.handleConfirmDiscard = __bind(this.handleConfirmDiscard, this);
      this.handleDiscard = __bind(this.handleDiscard, this);
      this.handleEquip = __bind(this.handleEquip, this);
      this.container = $('.item-menu');
      this.menu = this.container.find('.menu-items');
      this.actionMenu = new _cui.ItemActionMenu(this.ui, this, $('.item-action-menu'));
      this.actionMenuConfirm = new _cui.ItemActionMenuConfirm(this.ui, this, $('.item-action-menu-confirm'));
    }

    ItemMenu.prototype.init = function(options) {
      var cursorPos, i, item, menuItem, messageEl, selected, _i, _len, _ref;
      if (options == null) {
        options = {};
      }
      messageEl = this.container.find('.message');
      messageEl.hide();
      selected = this.menu.find('.selected');
      if (selected.size() !== 0) {
        cursorPos = selected.index();
      } else {
        cursorPos = 0;
      }
      if ('playerTurn' in options) {
        this.playerTurn = options.playerTurn;
        this.unit = this.playerTurn.selectedUnit;
        this.forceDiscard = false;
        cursorPos = 0;
      } else if ('forceDiscard' in options && options.forceDiscard) {
        this.unit = options.unit;
        this.callback = options.callback;
        this.forceDiscard = true;
        cursorPos = 0;
      }
      if (this.forceDiscard) {
        messageEl.text('Inventory full. Discard an item.').show();
      }
      this.menu.html('');
      i = 0;
      _ref = this.unit.inventory.it();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        menuItem = $('<div><div class="image"></div></div>');
        if (i === cursorPos) {
          menuItem.addClass('selected');
        }
        menuItem.data('index', i++);
        options = {
          usable: this.unit.canUse(item),
          equipped: this.unit.equipped === item
        };
        menuItem.append(item.getElement(options));
        menuItem.appendTo(this.menu);
      }
      this.show();
      this.menu.removeClass('in-submenu');
      return this.ui.controlState = new _cs.cui.ItemMenu(this.ui, this);
    };

    ItemMenu.prototype.getSelectedItem = function() {
      return this.menu.find('.selected .item-element').data('item');
    };

    ItemMenu.prototype.getSelectedIndex = function() {
      return this.menu.find('.selected').data('index');
    };

    ItemMenu.prototype.handleEquip = function() {
      this.unit.setEquipped(this.getSelectedItem());
      this.actionMenu.hide();
      this.ui.unitInfoBox.update();
      return this.init();
    };

    ItemMenu.prototype.handleDiscard = function() {
      this.actionMenu.hide();
      return this.actionMenuConfirm.init();
    };

    ItemMenu.prototype.handleConfirmDiscard = function() {
      this.unit.inventory.remove(this.getSelectedIndex());
      this.ui.unitInfoBox.update();
      this.actionMenuConfirm.hide();
      if (this.forceDiscard) {
        this.ui.controlState = new _cs.cui.Chapter(this.ui);
        this.hide();
        return this.callback();
      } else {
        if (this.unit.inventory.size() !== 0) {
          return this.init();
        } else {
          this.hide();
          return this.playerTurn.initActionMenu();
        }
      }
    };

    ItemMenu.prototype.show = function() {
      return this.container.css('display', 'inline-block');
    };

    ItemMenu.prototype.hide = function() {
      return this.container.css('display', 'none');
    };

    return ItemMenu;

  })();

  _cs.cui.ItemMenu = (function(_super) {
    __extends(ItemMenu, _super);

    function ItemMenu(ui, menuObj) {
      this.ui = ui;
      this.menuObj = menuObj;
    }

    ItemMenu.prototype.f = function() {
      return this.menuObj.actionMenu.init();
    };

    ItemMenu.prototype.d = function() {
      if (!this.menuObj.forceDiscard) {
        this.menuObj.hide();
        return this.ui.actionMenu.init();
      }
    };

    return ItemMenu;

  })(_cs.cui.Menu);

  _cui.ItemActionMenu = (function(_super) {
    __extends(ItemActionMenu, _super);

    function ItemActionMenu(ui, itemMenu, menu) {
      this.ui = ui;
      this.itemMenu = itemMenu;
      this.menu = menu;
      ItemActionMenu.__super__.constructor.call(this, this.ui);
    }

    ItemActionMenu.prototype.init = function() {
      var item, menuItems;
      item = this.itemMenu.getSelectedItem();
      menuItems = [];
      if (!this.itemMenu.forceDiscard) {
        if (this.itemMenu.unit.canWield(item)) {
          menuItems.push(new _cui.ActionMenuItem('Equip', this.itemMenu.handleEquip));
        }
      }
      menuItems.push(new _cui.ActionMenuItem('Discard', this.itemMenu.handleDiscard));
      ItemActionMenu.__super__.init.call(this, menuItems);
      this.itemMenu.menu.addClass('in-submenu');
      return this.ui.controlState = new _cs.cui.ItemActionMenu(this.ui, this);
    };

    return ItemActionMenu;

  })(_cui.ActionMenu);

  _cs.cui.ItemActionMenu = (function(_super) {
    __extends(ItemActionMenu, _super);

    function ItemActionMenu() {
      return ItemActionMenu.__super__.constructor.apply(this, arguments);
    }

    ItemActionMenu.prototype.f = function() {
      return this.menuObj.callSelectedHandler();
    };

    ItemActionMenu.prototype.d = function() {
      this.menuObj.hide();
      return this.menuObj.itemMenu.init();
    };

    return ItemActionMenu;

  })(_cs.cui.Menu);

  _cui.ItemActionMenuConfirm = (function(_super) {
    __extends(ItemActionMenuConfirm, _super);

    function ItemActionMenuConfirm(ui, itemMenu, container) {
      this.ui = ui;
      this.itemMenu = itemMenu;
      this.container = container;
      ItemActionMenuConfirm.__super__.constructor.call(this, this.ui);
      this.menu = this.container.find('.menu-items');
    }

    ItemActionMenuConfirm.prototype.init = function() {
      var menuItems;
      menuItems = [new _cui.ActionMenuItem('Yes, discard', this.itemMenu.handleConfirmDiscard)];
      ItemActionMenuConfirm.__super__.init.call(this, menuItems);
      return this.ui.controlState = new _cs.cui.ItemActionMenuConfirm(this.ui, this);
    };

    ItemActionMenuConfirm.prototype.show = function() {
      ItemActionMenuConfirm.__super__.show.call(this);
      return this.container.show();
    };

    ItemActionMenuConfirm.prototype.hide = function() {
      ItemActionMenuConfirm.__super__.hide.call(this);
      return this.container.hide();
    };

    return ItemActionMenuConfirm;

  })(_cui.ActionMenu);

  _cs.cui.ItemActionMenuConfirm = (function(_super) {
    __extends(ItemActionMenuConfirm, _super);

    function ItemActionMenuConfirm() {
      return ItemActionMenuConfirm.__super__.constructor.apply(this, arguments);
    }

    ItemActionMenuConfirm.prototype.f = function() {
      return this.menuObj.callSelectedHandler();
    };

    ItemActionMenuConfirm.prototype.d = function() {
      this.menuObj.hide();
      return this.menuObj.itemMenu.actionMenu.init();
    };

    return ItemActionMenuConfirm;

  })(_cs.cui.Menu);

}).call(this);
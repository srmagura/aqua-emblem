// Generated by CoffeeScript 1.8.0
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window._status = {};

  _status.Status = (function() {
    function Status() {}

    Status.prototype.replaceOther = false;

    Status.prototype.onEnemyTurn = function() {};

    Status.prototype.newTurn = function(unit) {
      return this.turns--;
    };

    Status.prototype.getEl = function() {
      var clsName, div, img, span;
      div = $('<div></div>').addClass('status');
      clsName = _util.getFunctionName(this.constructor).toLowerCase();
      div.addClass('status-' + clsName);
      img = $('<img/>').attr('src', this.getImagePath());
      span = $('<span></span>').html(this.text);
      div.append(img).append(span);
      return div;
    };

    Status.prototype.getImagePath = function() {
      return 'images/' + this.imagePath;
    };

    return Status;

  })();

  _status.Defend = (function(_super) {
    __extends(Defend, _super);

    function Defend() {
      this.text = 'Defend';
      this.imagePath = 'skills/defend.png';
      this.turns = 1;
    }

    return Defend;

  })(_status.Status);

  _status.Buff = (function(_super) {
    __extends(Buff, _super);

    function Buff(stat, value) {
      this.stat = stat;
      this.value = value;
      this.imagePath = 'up_arrow.png';
      this.turns = this.value;
      this.updateText();
    }

    Buff.prototype.updateText = function() {
      this.text = "<span class='stat'>" + (this.stat.toUpperCase()) + "</span>";
      return this.text += ' +' + this.value;
    };

    Buff.prototype.newTurn = function(unit) {
      this.value--;
      this.updateText();
      return Buff.__super__.newTurn.call(this);
    };

    return Buff;

  })(_status.Status);

  _status.Poison = (function(_super) {
    __extends(Poison, _super);

    function Poison(dmg) {
      this.dmg = dmg;
      this.imagePath = 'skills/poison_arrow.png';
      this.turns = 3;
      this.replaceOther = true;
      this.updateText();
    }

    Poison.prototype.updateText = function() {
      return this.text = "Poison (" + this.turns + ")";
    };

    Poison.prototype.newTurn = function(unit) {
      Poison.__super__.newTurn.call(this);
      this.dmg -= 2;
      if (this.dmg <= 0) {
        this.dmg = 1;
      }
      return this.updateText();
    };

    return Poison;

  })(_status.Status);

  _status.PoisonAction = (function() {
    function PoisonAction() {}

    PoisonAction.prototype.getMessageEl = function() {
      return _skill.getMessageEl({
        imagePath: 'images/skills/poison_arrow.png',
        text: 'Poison'
      });
    };

    return PoisonAction;

  })();

  _status.ThrowingKnives = (function(_super) {
    __extends(ThrowingKnives, _super);

    function ThrowingKnives() {
      this.imagePath = 'skills/throwing_knives.png';
      this.turns = 3;
      this.replaceOther = true;
      this.updateText();
    }

    ThrowingKnives.prototype.updateText = function() {
      return this.text = "Throwing Knives (" + this.turns + ")";
    };

    ThrowingKnives.prototype.newTurn = function(unit) {
      ThrowingKnives.__super__.newTurn.call(this, unit);
      this.updateText();
      if (unit.inventory.items[0] instanceof _item.ThrowingKnives) {
        return unit.inventory.remove(0);
      }
    };

    ThrowingKnives.prototype.onEnemyTurn = function(unit) {
      unit.inventory.prepend(new _item.ThrowingKnives());
      return unit.inventory.refresh();
    };

    return ThrowingKnives;

  })(_status.Status);

}).call(this);
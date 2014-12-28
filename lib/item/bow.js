// Generated by CoffeeScript 1.8.0
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  _item.IronBow = (function(_super) {
    __extends(IronBow, _super);

    function IronBow() {
      IronBow.__super__.constructor.call(this);
      this.name = 'Iron bow';
      this.hit = 85;
      this.might = 6;
      this.weight = 5;
    }

    return IronBow;

  })(_item.Bow);

  _item.ThrowingKnives = (function(_super) {
    __extends(ThrowingKnives, _super);

    function ThrowingKnives() {
      ThrowingKnives.__super__.constructor.call(this);
      this.name = 'Throwing knives';
      this.image = '../skills/throwing_knives.png';
      this.range = new Range(1, 2);
    }

    ThrowingKnives.prototype.getMessageEl = function() {
      return _skill.getMessageEl({
        imagePath: 'images/skills/throwing_knives.png',
        text: this.name + '!',
        spanClass: 'small'
      });
    };

    return ThrowingKnives;

  })(_item.IronBow);

  _item.SteelBow = (function(_super) {
    __extends(SteelBow, _super);

    function SteelBow() {
      SteelBow.__super__.constructor.call(this);
      this.name = 'Steel bow';
      this.image = 'steel_bow.png';
      this.hit = 75;
      this.might = 9;
      this.weight = 5;
      this.uses = _item.uses.steel;
    }

    return SteelBow;

  })(_item.Bow);

  _item.KillerBow = (function(_super) {
    __extends(KillerBow, _super);

    function KillerBow() {
      KillerBow.__super__.constructor.call(this);
      this.name = 'Killer bow';
      this.image = 'killer_bow.png';
      this.hit = 75;
      this.might = 7;
      this.weight = 7;
      this.crit = 30;
      this.uses = _item.uses.killer;
    }

    return KillerBow;

  })(_item.Bow);

}).call(this);
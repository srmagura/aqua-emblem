// Generated by CoffeeScript 1.7.1
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.uclass = {
    special: {}
  };

  window.uclass.Mercenary = (function(_super) {
    __extends(Mercenary, _super);

    function Mercenary(attr) {
      var baseStats;
      this.uclassName = 'Mercenary';
      this.wield = [item.Sword];
      baseStats = {
        baseHp: 18,
        move: 5,
        str: 3,
        def: 2,
        skill: 4,
        speed: 4,
        res: 1,
        luck: 2,
        mag: 0
      };
      this.fillInBaseStats(baseStats);
      if (this.growthRates == null) {
        this.growthRates = {
          baseHp: .8,
          str: .5,
          skill: .35,
          speed: .35,
          luck: .1,
          def: .25,
          res: .15
        };
      }
      Mercenary.__super__.constructor.call(this, attr);
    }

    return Mercenary;

  })(Unit);

  window.uclass.Archer = (function(_super) {
    __extends(Archer, _super);

    function Archer(attr) {
      var baseStats;
      this.uclassName = 'Archer';
      this.wield = [item.Bow];
      baseStats = {
        baseHp: 16,
        move: 5,
        str: 2,
        def: 2,
        skill: 3,
        speed: 3,
        res: 1,
        luck: 2,
        mag: 0
      };
      this.fillInBaseStats(baseStats);
      if (this.growthRates == null) {
        this.growthRates = {
          baseHp: .65,
          str: .4,
          skill: .45,
          speed: .40,
          luck: .1,
          def: .25,
          res: .15
        };
      }
      Archer.__super__.constructor.call(this, attr);
    }

    return Archer;

  })(Unit);

  window.uclass.Soldier = (function(_super) {
    __extends(Soldier, _super);

    function Soldier(attr) {
      var baseStats;
      this.uclassName = 'Soldier';
      this.wield = [item.Lance];
      baseStats = {
        baseHp: 20,
        move: 5,
        str: 2,
        def: 4,
        skill: 2,
        speed: 2,
        res: 1,
        luck: 2,
        mag: 0
      };
      this.fillInBaseStats(baseStats);
      if (this.growthRates == null) {
        this.growthRates = {
          baseHp: .8,
          str: .5,
          skill: .35,
          speed: .35,
          luck: .1,
          def: .25,
          res: .15
        };
      }
      Soldier.__super__.constructor.call(this, attr);
    }

    return Soldier;

  })(Unit);

  window.uclass.Fighter = (function(_super) {
    __extends(Fighter, _super);

    function Fighter(attr) {
      var baseStats;
      this.uclassName = 'Fighter';
      this.wield = [item.Axe];
      baseStats = {
        baseHp: 23,
        move: 5,
        str: 3,
        def: 1,
        skill: 1,
        speed: 2,
        res: 1,
        luck: 2,
        mag: 0
      };
      this.fillInBaseStats(baseStats);
      if (this.growthRates == null) {
        this.growthRates = {
          baseHp: .8,
          str: .5,
          skill: .35,
          speed: .35,
          luck: .1,
          def: .25,
          res: .15
        };
      }
      Fighter.__super__.constructor.call(this, attr);
    }

    return Fighter;

  })(Unit);

  window.uclass.special.Ace = (function(_super) {
    __extends(Ace, _super);

    function Ace() {
      this.name = 'Ace';
      this.level = 2;
      this.picture = true;
      this.inventory = [new item.IronSword()];
      this.baseStats = {
        baseHp: 30,
        baseMp: 10,
        str: 6,
        def: 4,
        skill: 3.8,
        speed: 5,
        res: 2,
        luck: 8,
        mag: 0
      };
      this.growthRates = {
        baseHp: .7,
        baseMp: 1,
        str: .5,
        skill: .35,
        speed: .35,
        luck: .5,
        def: .4,
        res: .15
      };
      Ace.__super__.constructor.call(this);
    }

    return Ace;

  })(uclass.Mercenary);

  window.uclass.special.Arrow = (function(_super) {
    __extends(Arrow, _super);

    function Arrow() {
      this.name = 'Arrow';
      this.level = 1;
      this.picture = true;
      this.inventory = [new item.IronBow()];
      this.inventory.push(new item.IronBow());
      this.baseStats = {
        baseHp: 24,
        baseMp: 10,
        str: 4,
        def: 4,
        skill: 4.0,
        speed: 4.1,
        res: 2,
        luck: 2,
        mag: 0
      };
      this.growthRates = {
        baseHp: .65,
        baseMp: 1,
        str: .4,
        skill: .45,
        speed: .45,
        luck: .6,
        def: .25,
        res: .15
      };
      Arrow.__super__.constructor.call(this);
    }

    return Arrow;

  })(uclass.Archer);

  window.uclass.special.Luciana = (function(_super) {
    __extends(Luciana, _super);

    function Luciana() {
      this.name = 'Luciana';
      this.level = 3;
      this.picture = true;
      this.inventory = [new item.IronLance()];
      this.inventory.push(new item.IronBow());
      this.baseStats = {
        baseHp: 28,
        baseMp: 10,
        str: 3.5,
        def: 6,
        skill: 3.8,
        speed: 3.2,
        res: 2,
        luck: 4,
        mag: 0
      };
      this.growthRates = {
        baseHp: .8,
        baseMp: 1,
        str: .4,
        skill: .35,
        speed: .35,
        luck: .3,
        def: .5,
        res: .15
      };
      Luciana.__super__.constructor.call(this);
    }

    return Luciana;

  })(uclass.Soldier);

  window.uclass.special.Kenji = (function(_super) {
    __extends(Kenji, _super);

    function Kenji() {
      this.name = 'Kenji';
      this.level = 2;
      this.picture = true;
      this.inventory = [new item.IronAxe()];
      this.baseStats = {
        baseHp: 36,
        baseMp: 10,
        str: 7,
        def: 3.5,
        skill: 4,
        speed: 5,
        res: 2,
        luck: 4,
        mag: 0
      };
      this.growthRates = {
        baseHp: .8,
        baseMp: 1,
        str: .5,
        skill: .35,
        speed: .35,
        luck: .45,
        def: .35,
        res: .15
      };
      Kenji.__super__.constructor.call(this);
    }

    return Kenji;

  })(uclass.Fighter);

}).call(this);
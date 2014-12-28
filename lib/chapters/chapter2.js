// Generated by CoffeeScript 1.8.0
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  _chapters.Chapter2 = (function(_super) {
    __extends(Chapter2, _super);

    function Chapter2(ui) {
      var agg, enemyUnits, halt, map, obj, playerPositions, reinforcements, reinforcements1, terrainMapping, tiles, turn, unit, _i, _j, _len, _len1, _ref;
      this.ui = ui;
      halt = _unit.aiType.halt;
      agg = _unit.aiType.aggressive;
      enemyUnits = [
        new _enemy.Archer({
          pos: new Position(0, 8),
          level: 3
        }), new _enemy.Archer({
          pos: new Position(0, 9),
          level: 2,
          aiType: agg
        }), new _enemy.Soldier({
          pos: new Position(7, 2),
          level: 2,
          aiType: agg
        }), new _enemy.Soldier({
          pos: new Position(7, 8),
          level: 2,
          aiType: agg
        }), new _enemy.Soldier({
          pos: new Position(4, 7),
          level: 2,
          aiType: agg
        }), new _enemy.Soldier({
          pos: new Position(4, 11),
          level: 3
        }), new _enemy.Mercenary({
          pos: new Position(6, 10),
          level: 2,
          aiType: agg
        }), new _enemy.Mercenary({
          pos: new Position(2, 10),
          level: 3,
          items: [new _item.SteelSword().letDrop()]
        }), new _enemy.Soldier({
          pos: new Position(9, 5),
          level: 3
        }), new _enemy.Archer({
          pos: new Position(14, 0),
          level: 2,
          aiType: agg
        }), new _enemy.Archer({
          pos: new Position(15, 1),
          level: 2,
          items: [new _item.SteelBow().letDrop()],
          aiType: agg
        }), new _enemy.Soldier({
          pos: new Position(14, 11),
          level: 3
        }), new _enemy.Mercenary({
          pos: new Position(14, 9),
          level: 2,
          aiType: halt
        }), new _enemy.Soldier({
          pos: new Position(12, 3),
          level: 2,
          aiType: agg
        }), new _enemy.Soldier({
          pos: new Position(13, 5),
          level: 2,
          aiType: agg
        }), new _enemy.Mercenary({
          pos: new Position(10, 7),
          level: 3
        }), new _enemy.Mercenary({
          pos: new Position(15, 8),
          level: 3
        }), new _enemy.Mercenary({
          pos: new Position(15, 4),
          level: 2
        }), new _enemy.Fighter({
          pos: new Position(15, 10),
          name: 'Morgan',
          boss: true,
          picture: true,
          level: 10,
          aiType: halt,
          items: [new _item.HandAxe(), new _item.SteelAxe().letDrop()]
        })
      ];
      reinforcements1 = [
        {
          cls: _enemy.Soldier,
          attr: {
            pos: new Position(0, 9),
            level: 2,
            items: [new _item.IronLance()],
            aiType: agg
          }
        }, {
          cls: _enemy.Mercenary,
          attr: {
            pos: new Position(15, 1),
            level: 2,
            items: [new _item.IronSword()],
            aiType: agg
          }
        }, {
          cls: _enemy.Archer,
          attr: {
            pos: new Position(14, 0),
            level: 2,
            items: [new _item.IronBow()],
            aiType: agg
          }
        }
      ];
      reinforcements = [];
      _ref = [4, 6, 8];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        turn = _ref[_i];
        for (_j = 0, _len1 = reinforcements1.length; _j < _len1; _j++) {
          obj = reinforcements1[_j];
          unit = new obj.cls(obj.attr);
          unit.spawnTurn = turn;
          reinforcements.push(unit);
        }
      }
      this.enemyTeam = new _team.EnemyTeam(enemyUnits, {
        defaultName: 'Sellsword',
        reinforcements: reinforcements
      });
      terrainMapping = {
        0: _terrain.Plain,
        1: _terrain.Rocks,
        2: _terrain.Forest,
        3: _terrain.River,
        4: _terrain.Bridge,
        5: _terrain.Fort
      };
      tiles = [[2, 2, 0, 2, 1, 1, 0, 2, 5, 5, 2, 0], [0, 0, 0, 2, 1, 1, 0, 0, 2, 0, 0, 0], [2, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, 2], [0, 0, 0, 1, 1, 2, 0, 0, 0, 0, 0, 2], [1, 2, 0, 0, 0, 2, 0, 2, 2, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2], [0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2], [0, 0, 0, 2, 2, 0, 0, 0, 0, 2, 2, 2], [3, 3, 3, 3, 3, 4, 3, 3, 3, 3, 3, 3], [0, 2, 2, 0, 0, 0, 0, 2, 0, 0, 2, 2], [0, 0, 0, 0, 2, 0, 0, 0, 0, 2, 0, 0], [0, 2, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0], [2, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0], [5, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 2], [0, 5, 0, 2, 2, 2, 2, 0, 0, 0, 2, 0]];
      playerPositions = [[0, 1], [1, 0], [2, 1], [1, 2]];
      this.origin0 = new Position(6 * this.ui.tw, 0);
      this.victoryCondition = _map.VICTORY_CONDITION.ROUT;
      map = new _map.Map(tiles, terrainMapping, playerPositions);
      Chapter2.__super__.constructor.call(this, this.ui, map);
    }

    Chapter2.prototype.doScrollSequence = function(callback) {
      var f;
      f = (function(_this) {
        return function() {
          return _this.ui.scrollTo(new Position(0, 0), callback, .07);
        };
      })(this);
      return setTimeout(f, 1000 / this.ui.speedMultiplier);
    };

    return Chapter2;

  })(_map.Chapter);

}).call(this);
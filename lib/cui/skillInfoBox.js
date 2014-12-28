// Generated by CoffeeScript 1.8.0
(function() {
  _cui.SkillInfoBox = (function() {
    function SkillInfoBox(ui, box) {
      this.ui = ui;
      this.box = box;
    }

    SkillInfoBox.prototype.init = function(skill, usable, full) {
      var desc, heading, stats;
      if (full == null) {
        full = true;
      }
      if (!usable) {
        this.box.addClass('not-usable');
      } else {
        this.box.removeClass('not-usable');
      }
      heading = this.box.find('.heading');
      heading.find('img').attr('src', skill.getImagePath());
      heading.find('span').text(skill.name);
      stats = this.box.find('.stats');
      desc = this.box.find('.desc');
      if (full) {
        this.initStats(skill, stats);
        desc.text(skill.desc).show();
      } else {
        stats.hide();
        desc.hide();
      }
      return this.show();
    };

    SkillInfoBox.prototype.initStats = function(skill, stats) {
      var getAttr, half, html, key, keys, _i, _len;
      getAttr = function(key) {
        if (key === 'type' && skill.type instanceof _skill.type.None) {
          return null;
        } else if (skill[key] == null) {
          return null;
        }
        if (key === 'range') {
          return skill[key].toString();
        } else if (key === 'type') {
          return skill[key].getEl();
        } else {
          return skill[key];
        }
      };
      keys = ['mp', 'type', 'hit', 'might', 'crit', 'range'];
      for (_i = 0, _len = keys.length; _i < _len; _i++) {
        key = keys[_i];
        html = getAttr(key);
        half = stats.find(".half-" + key);
        if (html != null) {
          half.show();
          half.find('.value').html(html);
        } else {
          half.hide();
        }
      }
      return stats.show();
    };

    SkillInfoBox.prototype.show = function() {
      return this.box.css('display', 'block');
    };

    SkillInfoBox.prototype.hide = function() {
      return this.box.css('display', 'none');
    };

    return SkillInfoBox;

  })();

}).call(this);
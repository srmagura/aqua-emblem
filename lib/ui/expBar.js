// Generated by CoffeeScript 1.7.1
(function() {
  window.ExpBar = (function() {
    function ExpBar(ui) {
      this.ui = ui;
      this.container = $('.exp-bar-container');
    }

    ExpBar.prototype.init = function(unit, toAdd, callback) {
      var afterAnimate, afterAnimateLevelUp, afterDelay, barFilled, css, msPerExp, newExp, time, totalWidth, width0, width1;
      css = this.ui.centerElement(this.container, 5);
      this.container.css(css);
      totalWidth = this.container.find('.exp-bar').width();
      width0 = totalWidth * unit.exp;
      barFilled = this.container.find('.exp-bar-filled');
      barFilled.width(width0);
      afterAnimateLevelUp = (function(_this) {
        return function() {
          var time, width2;
          time = msPerExp * (newExp - 1);
          width2 = (newExp - 1) * totalWidth;
          barFilled.css('width', 0);
          return barFilled.animate({
            width: width2
          }, time, afterAnimate);
        };
      })(this);
      afterAnimate = (function(_this) {
        return function() {
          return setTimeout(afterDelay, 1000);
        };
      })(this);
      afterDelay = (function(_this) {
        return function() {
          _this.hide();
          return callback();
        };
      })(this);
      this.show();
      newExp = unit.exp + toAdd;
      msPerExp = 1500;
      if (newExp >= 1) {
        time = msPerExp * (1 - unit.exp);
        return barFilled.animate({
          width: totalWidth
        }, time, afterAnimateLevelUp);
      } else {
        width1 = totalWidth * newExp;
        return barFilled.animate({
          width: width1
        }, msPerExp * toAdd, afterAnimate);
      }
    };

    ExpBar.prototype.show = function() {
      return this.container.css('visibility', 'visible');
    };

    ExpBar.prototype.hide = function() {
      return this.container.css('visibility', 'hidden');
    };

    return ExpBar;

  })();

}).call(this);
// Generated by CoffeeScript 1.8.0
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window._vn = {};

  _cs.vn = {};

  _vn.VisualNovelUI = (function(_super) {
    __extends(VisualNovelUI, _super);

    function VisualNovelUI() {
      VisualNovelUI.__super__.constructor.call(this);
      this.setConfirmUnload(true);
      this.wrapper = $('.vn-wrapper').show();
      this.controlState = new _cs.ControlState(this);
      this.fullTextbox = new _vn.FullTextbox(this);
      this.chapterDisplay = new _vn.ChapterDisplay(this);
      this.scene = new _vn.Scene(this);
      this.units = {
        'ace': new _unit.special.Ace(),
        'arrow': new _unit.special.Arrow(),
        'luciana': new _unit.special.Luciana(),
        'kenji': new _unit.special.Kenji(),
        'shiina': new _unit.special.Shiina(),
        'morgan': new _unit.Unit({
          name: 'Morgan'
        })
      };
    }

    VisualNovelUI.prototype.destroy = function(callback) {
      if (callback != null) {
        return this.wrapper.fadeOut(1000, callback);
      } else {
        return this.wrapper.hide();
      }
    };

    return VisualNovelUI;

  })(UI);

  _vn.setBackgroundImage = function(el, name) {
    var bgPrefix, value;
    bgPrefix = 'images/vn/backgrounds/';
    value = "url('" + bgPrefix + name + ".png')";
    return el.css('background-image', value);
  };

}).call(this);
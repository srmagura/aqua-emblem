window._vn = {}
_cs.vn = {}

class _vn.VisualNovelUI extends UI

    constructor: ->
        super()
        @setConfirmUnload(true)
        @wrapper = $('.vn-wrapper').show()
        @controlState = new _cs.ControlState(this)

        @fullTextbox = new _vn.FullTextbox(this)
        @chapterDisplay = new _vn.ChapterDisplay(this)
        @scene = new _vn.Scene(this)
        
        @units = {
            'ace': new _unit.special.Ace(),
            'arrow': new _unit.special.Arrow(),
            'luciana': new _unit.special.Luciana(),
            'kenji': new _unit.special.Kenji(),
            'shiina': new _unit.special.Shiina(),
            'morgan': new _unit.Unit({name: 'Morgan'})
        }

    destroy: (callback) ->
        if callback?
            @wrapper.fadeOut(1000, callback)
        else
            @wrapper.hide()
                     

 
_vn.setBackgroundImage = (el, name) ->
    bgPrefix = 'images/vn/backgrounds/'
    value = "url('#{bgPrefix}#{name}.png')"
    el.css('background-image', value)

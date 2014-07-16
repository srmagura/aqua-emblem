window._vn = {}
_cs.vn = {}

class _vn.VisualNovelUI extends UI

    constructor: ->
        super()
        @wrapper = $('.vn-wrapper').show()
        @controlState = new _cs.ControlState(this)

        @fullTextbox = new _vn.FullTextbox(this)
        @chapterDisplay = new _vn.ChapterDisplay(this)
        @scene = new _vn.Scene(this)

    destroy: (callback) ->
        if callback?
            @wrapper.fadeOut(1000, callback)
        else
            @wrapper.hide()

 
_vn.setBackgroundImage = (el, name) ->
    bgPrefix = 'images/vn/backgrounds/'
    value = "url('#{bgPrefix}#{name}.png')"
    el.css('background-image', value)

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

    destroy: ->
        @wrapper.hide()

 
_vn.setBackgroundImage = (el, path) ->
    bgPrefix = 'images/vn/backgrounds/'
    value = "url('#{bgPrefix + path}')"
    el.css('background-image', value)

window._vn = {}
_cs.vn = {}

class _vn.VisualNovelUI extends UI

    constructor: ->
        super()
        @vn = new _vn.VisualNovel(this)
        @vn.show()
        @controlState = new _cs.ControlState(this)

        @fullTextbox = new _vn.FullTextbox(this)
        @chapterDisplay = new _vn.ChapterDisplay(this)
        @scene = new _vn.Scene(this)

    destroy: ->
        @vn.hide()

class _vn.VisualNovel

    constructor: (@ui) ->
        @wrapper = $('.vn-wrapper')
        @bgEl = @wrapper.find('.background').html('')
        @bgPrefix = 'images/vn/backgrounds/'

    setBackgroundImage: (path) ->
        img = $('<img />').attr('src', @bgPrefix + path)
        @bgEl.html('').append(img)

    show: -> @wrapper.show()

    hide: -> @wrapper.hide()


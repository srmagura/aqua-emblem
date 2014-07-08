window._vn = {}
_cs.vn = {}

class _vn.VisualNovelUI extends UI

    constructor: ->
        super()
        @vn = new _vn.VisualNovel(this)
        @vn.show()
        @controlState = new _cs.ControlState(this)

        @fullTextbox = new _vn.FullTextbox(this)

    destroy: ->
        @vn.hide()

class _vn.VisualNovel

    constructor: (@ui) ->
        @wrapper = $('.vn-wrapper')
        @bgEl = @wrapper.find('.background').html('')

    setBackgroundImage: (path) ->
        img = $('<img />').attr('src', path)
        @bgEl.html('').append(img)

    show: -> @wrapper.show()

    hide: -> @wrapper.hide()

_vn.animateText = (el, text, callback=(->)) ->
    msPerChar = 15

    $({count: 0}).animate({count: text.length}, {
        duration: text.length*msPerChar,
        step: -> el.text(text.substring(0, Math.round(@count))),
        complete: callback
    })

_vn.animateTextWithArrow = (el, text, callback=(->)) ->
    callback2 = =>
        img = $('<img />').attr('src', 'images/vn_arrow.png')
        img.addClass('vn-arrow').appendTo(el)
        callback()

    _vn.animateText(el, text, callback2)

class _vn.FullTextbox

    constructor: (@ui) ->
        @vn = @ui.vn
        @wrapper = @vn.wrapper.find('.full-textbox')
        @box = @wrapper.find('.box')

    init: (@lines, @callback) ->
        @vn.bgEl.addClass('dark')
        @box.html('')

        @show()
        @lineIndex = 0
        @animateLine()

    animateLine: ->
        callback = =>
            @ui.controlState = new _cs.vn.FullTextbox(@ui, this)

        @box.find('.line').last().find('.vn-arrow').
            css('visibility', 'hidden')

        if @lineIndex == @lines.length
            @callback()
            return

        @ui.controlState = new _cs.ControlState(@ui)
        el = $('<div></div>').addClass('line').appendTo(@box)
        _vn.animateTextWithArrow(el, @lines[@lineIndex++], callback)

    show: -> @wrapper.show()

    hide: -> @wrapper.hide()

class _cs.vn.FullTextbox extends _cs.ControlState
    
    constructor: (@ui, @boxObj) ->

    f: ->
        @boxObj.animateLine()

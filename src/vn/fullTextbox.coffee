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
        @fadeDelay = 1000

    init: (@lines, @callback) ->
        @box.html('')

        @lineIndex = 0
        @wrapper.fadeIn(@fadeDelay, @animateLine)

    animateLine: =>
        callback = =>
            @ui.controlState = new _cs.vn.FullTextbox(@ui, this)

        @box.find('.line').last().find('.vn-arrow').
            css('visibility', 'hidden')
        @ui.controlState = new _cs.ControlState(@ui)

        if @lineIndex == @lines.length
            @wrapper.fadeOut(1000, @callback)
            return

        el = $('<div></div>').addClass('line').appendTo(@box)
        _vn.animateTextWithArrow(el, @lines[@lineIndex++], callback)

    show: -> @wrapper.show()

    hide: -> @wrapper.hide()

class _cs.vn.FullTextbox extends _cs.ControlState
    
    constructor: (@ui, @boxObj) ->

    f: ->
        @boxObj.animateLine()

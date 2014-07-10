_vn.animateText = (el, text, callback=(->)) ->
    msPerChar = 30

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

    init: (@pages, @callback) ->
        @ui.controlState = new _cs.vn.FullTextbox(@ui, this)
        @callbackMade = false

        @box.html('')

        @pageIndex = 0
        @lineIndex = 0
        @wrapper.fadeIn(@fadeDelay, @animateLine)

    animateLine: =>
        if @callbackMade
            return

        callback = =>
            @ui.controlState = new _cs.vn.FullTextboxWaiting(@ui, this)

        @box.find('.line').last().find('.vn-arrow').
            css('visibility', 'hidden')
        @ui.controlState = new _cs.vn.FullTextbox(@ui, this)

        lines = @pages[@pageIndex]
        if @lineIndex == lines.length
            if @pageIndex == @pages.length-1
                @wrapper.fadeOut(@fadeDelay, @done)
                return
            else
                @pageIndex++
                @box.html('')

                lines = @pages[@pageIndex]
                @lineIndex = 0

        el = $('<div></div>').addClass('line').appendTo(@box)
        _vn.animateTextWithArrow(el, lines[@lineIndex++], callback)

    skip: ->
        @wrapper.hide()
        @done()

    done: =>
        if not @callbackMade
            @callbackMade = true
            @callback()

    show: -> @wrapper.show()

    hide: -> @wrapper.hide()

class _cs.vn.FullTextbox extends _cs.ControlState
    
    constructor: (@ui, @boxObj) ->

    v: ->
        @boxObj.skip()

class _cs.vn.FullTextboxWaiting extends _cs.vn.FullTextbox

    f: ->
        @boxObj.animateLine()


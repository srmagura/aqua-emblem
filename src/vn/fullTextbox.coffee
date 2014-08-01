animateText = (el, text, callback, check) ->
    msPerChar = 30

    spans = []
    el.html('')

    for char in text
        span = $('<span></span>').text(char)
        span.css('visibility', 'hidden')

        el.append(span)
        spans.push(span)

    spanI = 0

    $({count: 0}).animate({count: text.length}, {
        duration: text.length*msPerChar,
        step: ->
            if not check()
                return
        
            rounded = Math.round(@count)
            if rounded >= spanI
                for j in [spanI .. rounded]
                    if j == spans.length
                        return

                    spans[j].css('visibility', 'visible')

            spanI = rounded+1

        complete: callback
    })

_vn.animateTextWithArrow = (options) ->
    if options.callback?
        callback = options.callback
    else
        callback = (->)
        
    if options.check?
        check = options.check
    else
        check = (-> true)

    callback2 = =>
        if check()
            img = $('<img />').attr('src', 'images/vn/arrow.png')
            img.addClass('vn-arrow').appendTo(options.el)
            callback()

    animateText(options.el, options.text, callback2, check)

class _vn.FullTextbox

    constructor: (@ui) ->
        @wrapper = @ui.wrapper.find('.full-textbox')
        @box = @wrapper.find('.box')
        @fadeDelay = 1000

    init: (@pages, @callback) ->
        @ui.controlState = new _cs.vn.FullTextbox(@ui, this)
        @callbackMade = false

        @box.html('')

        @pageIndex = 0
        @lineIndex = 0
        @wrapper.fadeIn(@fadeDelay, @showLine)

    showLine: =>
        if @callbackMade
            return

        callback = =>
            if not @callbackMade
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
        _vn.animateTextWithArrow({
            el: el, 
            text: lines[@lineIndex++], 
            callback: callback
        })

    skip: ->
        @wrapper.hide()
        @done()

    done: =>
        if not @callbackMade
            @callbackMade = true
            @callback()


class _cs.vn.FullTextbox extends _cs.ControlState
    
    constructor: (@ui, @boxObj) ->

    v: ->
        @boxObj.skip()

class _cs.vn.FullTextboxWaiting extends _cs.vn.FullTextbox

    f: ->
        @boxObj.showLine()


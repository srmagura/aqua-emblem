class _vn.Scene

    constructor: (@ui) ->
        @sceneId = 0

        @wrapper = @ui.wrapper.find('.scene')
        @chatbox = @wrapper.find('.chatbox')
        @locationBox = @wrapper.find('.location')

        @fadeDelay = 400
        @locationText = null

    init: (@lines, bgImage, @callback) ->
        @lineIndex = 0
        @callbackMade = false
        @locationBoxTimer = null

        @ui.controlState = new _cs.vn.Scene(@ui, this)
        _vn.setBackgroundImage(@wrapper, bgImage)

        @chatbox.find('.unit .image, .text').html('')
        @chatbox.find('.unit .name').hide()

        if @locationText?
            @locationBox.text(@locationText).show()
        else
            @locationBox.hide()

        @wrapper.fadeIn(@fadeDelay, @afterFadeIn)

    afterFadeIn: =>
        @showLine()

        @locationBoxTimer = @sceneId
        setTimeout(@fadeLocationBox, 3000)

    fadeLocationBox: =>
        if @locationBoxTimer == @sceneId
            @locationBox.fadeOut(@fadeDelay)

    showLine: ->
        if @callbackMade
            return

        @ui.controlState = new _cs.vn.Scene(@ui, this)

        if @lineIndex == @lines.length
            @wrapper.fadeOut(@fadeDelay, @done)
            return

        callback = =>
            @ui.controlState = new _cs.vn.SceneWaiting(@ui, this)

        lineObj = @lines[@lineIndex++]
        unit = @ui.units[lineObj[0]]
        text = lineObj[1]

        img = $('<img/>').attr('src', unit.getImagePath())
        @chatbox.find('.unit .image').html(img)
        @chatbox.find('.unit .name').text(unit.name).show()
        
        _vn.animateTextWithArrow(@chatbox.find('.text'), text, callback)

    skip: ->
        @wrapper.hide()
        @done()

    done: =>
        if not @callbackMade
            @callbackMade = true
            @locationText = null
            @sceneId++
            @callback()

class _cs.vn.Scene extends _cs.ControlState
    
    constructor: (@ui, @scene) ->

    v: ->
        @scene.skip()

class _cs.vn.SceneWaiting extends _cs.vn.Scene

    f: ->
        @scene.showLine()

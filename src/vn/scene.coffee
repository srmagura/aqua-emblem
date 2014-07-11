class _vn.Scene

    constructor: (@ui) ->
        @wrapper = @ui.wrapper.find('.scene')
        @chatbox = @wrapper.find('.chatbox')
        @fadeDelay = 400

    init: (@lines, bgImage) ->
        @lineIndex = 0

        _vn.setBackgroundImage(@wrapper, bgImage)

        @chatbox.find('.unit .image, .text').html('')
        @chatbox.find('.unit .name').hide()

        @wrapper.fadeIn(@fadeDelay, @afterFadeIn)

    afterFadeIn: =>
        @showLine()

    showLine: ->
        console.log('showLine')
        lineObj = @lines[@lineIndex]
        unit = lineObj[0]
        text = lineObj[1]

        img = $('<img/>').attr('src', unit.getImagePath())
        @chatbox.find('.unit .image').html(img)
        @chatbox.find('.unit .name').text(unit.name).show()
        
        _vn.animateTextWithArrow(@chatbox.find('.text'), text)

class _vn.Scene

    constructor: (@ui) ->
        @wrapper = @ui.vn.wrapper.find('.scene')
        @chatbox = @wrapper.find('.chatbox')

    init: (@lines, bgImage) ->
        @lineIndex = 0

        @ui.vn.bgEl.hide()
        @ui.vn.setBackgroundImage(bgImage)
        @ui.vn.bgEl.fadeIn(400, @afterFadeIn)

    afterFadeIn: =>
        @wrapper.show()
        @initChatbox()

    initChatbox: ->
        lineObj = @lines[@lineIndex]
        unit = lineObj[0]
        text = lineObj[1]

        img = $('<img/>').attr('src', unit.getImagePath())
        @chatbox.find('.unit .image').html(img)
        @chatbox.find('.unit .name').text(unit.name)
        
        _vn.animateTextWithArrow(@chatbox.find('.text'), text)

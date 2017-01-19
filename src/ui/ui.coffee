handlersSet = false

keydownHandler = (e) ->
    switch e.which
        when 38 then ui.controlState.up()
        when 40 then ui.controlState.down()
        when 37 then ui.controlState.left()
        when 39 then ui.controlState.right()
        when 70 then ui.controlState.f()
        when 68 then ui.controlState.d()
        when 83 then ui.controlState.s()
        when 69 then ui.controlState.e()
        when 86 then ui.controlState.v()

    prevent = [37, 38, 39, 40]
    if e.which in prevent
        e.preventDefault()
        return false

unloadStr = 'Are you sure you want to quit? If you do, your unsaved progress will be lost.'

class window.UI

    constructor: ->
        window.ui = this

        if not handlersSet
            $(window).keydown(keydownHandler)
            handlersSet = true

    setConfirmUnload: (bool) ->
        if bool
            window.onbeforeunload = (-> unloadStr)
        else
            window.onbeforeunload = null

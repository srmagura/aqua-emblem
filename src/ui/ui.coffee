class window.UI

    constructor: ->
        window.ui = this
        $(window).keydown(@keydownHandler)

    keydownHandler: (e) =>
        #console.log(e.which)
        switch e.which
            when 38 then @controlState.up()
            when 40 then @controlState.down()
            when 37 then @controlState.left()
            when 39 then @controlState.right()
            when 70 then @controlState.f()
            when 68 then @controlState.d()
            when 83 then @controlState.s()
            when 69 then @controlState.e()
            when 86 then @controlState.v()
            
        prevent = [37, 38, 39, 40]
        if e.which in prevent
            e.preventDefault()
            return false


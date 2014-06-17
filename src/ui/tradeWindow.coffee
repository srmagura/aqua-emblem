class window.TradeWindow

    constructor: (@ui) ->
        @window = $('.trade-window')

    init: (@unit1, @unit2) ->
        @window.html('')

        @initHalf(@unit1)
        @initHalf(@unit2)

        @ui.viewportOverlay.show()
        css = @ui.centerElement(@window, 0)
        @window.css(css)
        @show()

    initHalf: (unit) ->
        container = $('<div></div>').addClass('half')

        top = $('<div></div>').addClass('top')
        img = $('<img/>').attr('src', unit.getImagePath())
        img.appendTo(top)
        top.appendTo(container)

        inventory = $('<div></div>')
        inventory.addClass('inventory neutral-box')

        for item in unit.inventory
            usable = unit.canUse(item)
            inventory.append(item.getElement(usable))


        inventory.appendTo(container)
        container.appendTo(@window)

    show: ->
        @window.css('visibility', 'visible')

    hide: ->
        @window.css('visibility', 'hidden')

class _chapterui.UnitInfoBox

    constructor: (@ui, selector) ->
        @box = $(selector)

    update: ->
        unit = @ui.chapter.getUnitAt(@ui.cursor.pos)
        if unit?
            @init(unit, false, true)
            @show()
        else
            @hide()

    init: (unit, animate=false, showStatus=false) ->
        @box.removeClass('show-status')

        if unit.picture
            @box.find('img').attr('src', unit.getImagePath())
            @box.find('.image-wrapper').show()
        else
            @box.find('.image-wrapper').hide()

        @box.find('.name').text(unit.name)

        if unit.equipped?
            src = unit.equipped.getImagePath()
            @box.find('.equipped').attr('src', src)
        else
            @box.find('.equipped').removeAttr('src')

        @delay = 200 / @ui.speedMultiplier
        @populateHp(unit, animate)
        @populateMp(unit, animate)

        @box.find('.status-container').remove()
        if showStatus
            @showStatus(unit)

        @show()

    populateHp: (unit, animate) ->
        @box.find('.hp').text(unit.hp)
        @box.find('.max-hp').text(unit.maxHp)

        width = unit.hp / unit.maxHp * @box.find('.hp-bar').width()
        if animate
            @box.find('.hp-bar-filled').animate({width: width}, @delay)
        else
            @box.find('.hp-bar-filled').width(width)

    populateMp: (unit, animate) ->
        if 'maxMp' of unit
            @box.find('.mp').text(unit.mp)
            @box.find('.max-mp').text(unit.maxMp)

            width = unit.mp / unit.maxMp * @box.find('.mp-bar').width()
            if animate
                @box.find('.mp-bar-filled').animate({width: width}, @delay)
            else
                @box.find('.mp-bar-filled').width(width)
            
            @box.find('.mp-bar-container').show()
        else
            @box.find('.mp-bar-container').hide()

        if unit.team is @ui.chapter.playerTeam
            @box.removeClass('red-box').addClass('blue-box')
        else
            @box.removeClass('blue-box').addClass('red-box')

    showStatus: (unit) ->
        if unit.statuses.length == 0
            return

        container = $('<div></div>').addClass('status-container')
        @box.append(container).addClass('show-status')

        for status in unit.statuses
            container.append(status.getEl())

    show: ->
        @box.css('visibility', 'visible')

    hide: ->
        @box.css('visibility', 'hidden')

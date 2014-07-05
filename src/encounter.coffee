window.ENCOUNTER_DELAY = 1500

class window.Encounter

    constructor: (@ui, @atk, @def) ->

    doEncounter: (@callback) ->
        @container = $('<div></div>')
        @container.addClass('encounter-container').
        appendTo('.canvas-container')

        atkBoxEl = $('.sidebar .unit-info').clone()
        defBoxEl = $('.sidebar .unit-info').clone()

        if @atk.team instanceof PlayerTeam
            @leftBox = atkBoxEl
            @rightBox = defBoxEl

            @leftUnit = @atk
            @rightUnit = @def
        else
            @leftBox = defBoxEl
            @rightBox = atkBoxEl
            @leftUnit = @def
            @rightUnit = @atk

        @container.append(@leftBox).append(@rightBox)

        @atkBox = new UnitInfoBox(@ui, atkBoxEl)
        @atkBox.init(@atk)
        @atkBox.show()

        @defBox = new UnitInfoBox(@ui, defBoxEl)
        @defBox.init(@def)
        @defBox.show()

        @midpoint = @atk.pos.add(@def.pos).scale(.5)

        tw = @ui.tw

        left = @midpoint.j*tw - @leftBox.width() + 15 - @ui.origin.j

        if @atk.pos.i > @def.pos.i
            maxI = @atk.pos.i
        else
            maxI = @def.pos.i

        top = (maxI + 1)*tw - @ui.origin.i
        @container.css({left: left, top: top})

        @turnIndex = 0
        @delay = ENCOUNTER_DELAY / @ui.speedMultiplier

        setTimeout(@doAction, @delay/5)

    doLunge: (unit) =>
        reverse = =>
            setTimeout(halt, @delay/3)

        halt = =>
            unit.direction = null

        other = @getOther(unit)
        unit.direction = other.pos.subtract(unit.pos).toUnitVector()
        unit.movementSpeed = .025
        unit.lungeStatus = _unit.LUNGE_STATUS.FORWARD

    encounterDone: (doCallback=true) =>
        @container.remove()

        if doCallback and @callback?
            @callback()

    getOther: (unit) ->
        if unit is @atk
            return @def
        if unit is @def
            return @atk

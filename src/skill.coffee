class window.Range

    constructor: (@min, @max) ->
        if not @max?
            @max = @min

        if @min?
            @array = [@min..@max]
        else
            @array = []

    contains: (i) ->
        return i in @array

    union: (range) ->
        min = range.min
        if @min < min
            min = @min

        max = range.max
        if @max > max
            max = @max

        result = new Range(min, max)
        result.array = @array.concat(range.array)
        return result

    toString: ->
        return "#{@min}-#{@max}"

window._skill = {}

_skill.type = {}

_skill.type.NONE = {'name': ''}
_skill.type.PHYSICAL = {'name': 'PHYSICAL'}
_skill.type.MAGIC = {'name': 'MAGIC'}

class _skill.Skill

    constructor: ->
        @type = _skill.type.NONE
        @might = null
        @mp = 0

    getImagePath: ->
        return "images/skills/#{@imageName}.png"

    getMessageEl: ->
        message = $('<div></div>').addClass('action-message')

        img = $('<img/>').attr('src', @getImagePath())
        img.appendTo(message)

        span = $('<span></span>').text(@name + '!')
        span.appendTo(message)

        return message

    getControlState: (ui, playerTurn) ->
        return new @controlState(ui, playerTurn, this)


class _cs.Skill extends _cs.MapTarget

    constructor: (@ui, @playerTurn, @skill) ->

    f: ->
        @ui.cursor.visible = false
        @ui.unitInfoBox.hide()
        @ui.terrainBox.hide()
        @ui.skillInfoBox.hide()
        @ui.chapter.map.clearOverlay()
        @ui.controlState = new _cs.Chapter()

    d: ->
        @playerTurn.handleSkill()

    skillDone: =>
        @ui.unitInfoBox.init(@playerTurn.selectedUnit, false, true)
        @ui.controlState = new _cs.Map(@ui)
        @ui.cursor.visible = true
        @ui.terrainBox.show()
        @playerTurn.selectedUnit.setDone()
        @playerTurn.selectedUnit = null

class _skill.Defend extends _skill.Skill

    constructor: ->
        super()
        @name = 'Defend'
        @imageName = 'defend'
        @desc = 'During the next enemy turn, ' +
        'damage received is halved, but the unit cannot counterattack.'

        @mp = 2
        @range = new Range(0)
        @overlayType = 'AID'

        @controlState = _cs.Defend


class _cs.Defend extends _cs.Skill

    f: ->
        super()
        unit = @playerTurn.selectedUnit

        afterAction = =>
            unit.statuses.push(new _status.Defend())
            @skillDone()

        action = new UnitAction(@ui, unit)
        action.doAction(@skill, afterAction)


class _skill.FirstAid extends _skill.Skill

    constructor: ->
        super()
        @name = 'First aid'
        @imageName = 'first_aid'
        @type = _skill.type.MAGIC
        @desc = 'Basic healing skill.'

        @mp = 4
        @might = 10
        @range = new Range(0, 1)
        @overlayType = 'AID'

        @controlState = _cs.FirstAid

class _cs.FirstAid extends _cs.Skill

    f: ->
        super()
        unit = @playerTurn.selectedUnit

        action = new UnitAction(@ui, unit)
        delta = {hp: unit.mag + @skill.might}
        action.doAction(@skill, @skillDone, delta)

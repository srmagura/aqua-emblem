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

    getExp: ->
        return @mp*.02

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
        afterExpAdd = =>
            @ui.controlState = new _cs.Map(@ui)
            @ui.cursor.visible = true
            @ui.unitInfoBox.update()
            @ui.terrainBox.show()
            @playerTurn.selectedUnit.setDone()
            @playerTurn.selectedUnit = null

        _turn.addExp(@ui, afterExpAdd, @playerTurn.selectedUnit,
        @skill.getExp())

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
        unit = @playerTurn.selectedUnit
        if not @ui.cursor.pos.equals(unit.pos)
            return

        super()

        afterAction = =>
            unit.statuses.push(new _status.Defend())
            @skillDone()

        action = new _enc.UnitAction(@ui, unit)
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
        unit = @playerTurn.selectedUnit
        target = @ui.chapter.getUnitAt(@ui.cursor.pos)

        if not target or target.hp == target.baseHp
            return

        dist = unit.pos.distance(target.pos)
        if dist > @skill.range.max
            return

        super()

        delta = {hp: unit.mag + @skill.might}

        if unit is target
            action = new _enc.UnitAction(@ui, unit)
            action.doAction(@skill, @skillDone, delta)
        else
            encounter = new _enc.AidEncounter(@ui, unit, target)
            encounter.doEncounter(@skillDone, @skill, delta)

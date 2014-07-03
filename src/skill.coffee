window._skill = {}

_skill.type = {
    NONE: 0,
}

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

    skillDone: ->
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
        @range = [0]
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

window._status = {}

class _status.Status

    constructor: ->

    getEl: ->
        div = $('<div></div>').addClass('status')
        img = $('<img/>').attr('src', @imagePath)
        span = $('<span></span>').text(@text)

        div.append(img).append(span)
        return div

class _status.Defend extends _status.Status

    constructor: ->
        @text = 'Defend'
        @imagePath = 'images/skills/defend.png'
        @turns = 1

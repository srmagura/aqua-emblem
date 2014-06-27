window.skill = {}

skill.type = {
    NONE: 0,
}

class skill.Skill

    constructor: ->
        @type = skill.type.NONE
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


class CsSkill extends CsMapTarget

    constructor: (@ui, @playerTurn, @skl) ->

    f: ->
        @ui.cursor.visible = false
        @ui.unitInfoBox.hide()
        @ui.terrainBox.hide()
        @ui.skillInfoBox.hide()
        @ui.chapter.map.clearOverlay()
        @ui.controlState = new ControlState()

    d: ->
        @playerTurn.handleSkill()

    skillDone: ->
        @playerTurn.selectedUnit.setDone()
        @playerTurn.selectedUnit = null
        @ui.controlState = new CsMap(@ui)
        @ui.cursor.visible = true
        @ui.unitInfoBox.show()
        @ui.terrainBox.show()

class skill.Defend extends skill.Skill

    constructor: ->
        super()
        @name = 'Defend'
        @imageName = 'defend'
        @desc = 'During the next enemy turn, ' +
        'damage received is halved, but the unit cannot counterattack.'
        @cooldown = 1

        @range = [0]
        @overlayType = 'AID'

        @controlState = CsDefend


class CsDefend extends CsSkill

    f: ->
        super()

        afterAction = =>
            @skillDone()

        action = new UnitAction(@ui, @playerTurn.selectedUnit)
        action.doAction(@skl, afterAction)

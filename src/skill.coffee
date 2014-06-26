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

    getControlState: (ui, playerTurn) ->
        return new @controlState(ui, playerTurn, this)


class CsSkill extends CsMapTarget

    constructor: (@ui, @playerTurn, @skl) ->

    f: ->
        @ui.unitInfoBox.hide()
        @ui.terrainBox.hide()
        @ui.skillInfoBox.hide()
        @ui.chapter.map.clearOverlay()

    d: ->
        @playerTurn.handleSkill()


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
        action = new UnitAction(@ui, @playerTurn.selectedUnit)
        action.doAction(@skl, ->)

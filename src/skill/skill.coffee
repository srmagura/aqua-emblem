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

    isValidTarget: (target) -> true

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


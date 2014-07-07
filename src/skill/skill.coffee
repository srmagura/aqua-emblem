window._skill = {}

_skill.type = {}

class _skill.type.SkillType

    @getEl: ->
        imagePath = "images/items/#{@image}.png"
        $('<img />').attr('src', imagePath)

class _skill.type.None extends _skill.type.SkillType

class _skill.type.Holy extends _skill.type.SkillType
    @image: 'aquabolt'


class _skill.Skill

    constructor: ->
        @type = _skill.type.None
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

class _cs.cui.Skill extends _cs.cui.MapTarget

    constructor: (@ui, @playerTurn, @skill) ->

    f: ->
        @ui.cursor.visible = false
        @ui.unitInfoBox.hide()
        @ui.terrainBox.hide()
        @ui.skillInfoBox.hide()
        @ui.chapter.map.clearOverlay()
        @ui.controlState = new _cs.cui.Chapter(@ui)

    d: ->
        @ui.cursor.visible = false
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


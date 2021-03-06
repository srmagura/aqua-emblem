window._skill = {}

_skill.type = {}

class _skill.type.SkillType

    getEl: ->
        imagePath = "images/items/#{@image}.png"
        $('<img />').attr('src', imagePath)

class _skill.type.None extends _skill.type.SkillType

class _skill.type.Magic extends _skill.type.SkillType

class _skill.type.Holy extends _skill.type.Magic
    image: 'shine'

class _skill.type.Dark extends _skill.type.Magic
    image: 'fire'

class _skill.type.Physical extends _skill.type.SkillType

class _skill.type.Sword extends _skill.type.Physical
    image: 'iron_sword'

class _skill.type.Lance extends _skill.type.Physical
    image: 'iron_lance'

class _skill.type.Axe extends _skill.type.Physical
    image: 'iron_axe'

class _skill.type.Bow extends _skill.type.Physical
    image: 'iron_bow'


_skill.getMessageEl = (options) ->
    message = $('<div></div>').addClass('action-message')

    img = $('<img/>').attr('src', options.imagePath)
    img.appendTo(message)

    span = $('<span></span>').text(options.text)
    
    if 'spanClass' of options
        span.addClass(options.spanClass)
    
    span.appendTo(message)

    return message


class _skill.Skill

    constructor: ->
        @type = new _skill.type.None()
        @might = null
        @mp = 0

    getExp: ->
        return @mp*.02*ui.expMultiplier

    getImagePath: ->
        return "images/skills/#{@imageName}.png"

    getMessageEl: ->
        return _skill.getMessageEl({
            imagePath: @getImagePath(),
            text: @name + '!'
        })

    getControlState: (ui, playerTurn) ->
        return new @controlState(ui, playerTurn, this)

    isValidTarget: (target) -> true

class _cs.chapterui.Skill extends _cs.chapterui.MapTarget

    constructor: (@ui, @playerTurn, @skill) ->

    getUserTarget: ->
        user = @playerTurn.selectedUnit
        target = @ui.chapter.getUnitAt(@ui.cursor.pos)

        if not (target? and @skill.isValidTarget(target))
            return false

        dist = user.pos.distance(target.pos)
        if @skill.range.contains(dist)
            return {user: user, target: target}

        return false

    f: ->
        @ui.cursor.visible = false
        @ui.unitInfoBox.hide()
        @ui.terrainBox.hide()
        @ui.skillInfoBox.hide()
        @ui.chapter.map.clearOverlay()
        @ui.controlState = new _cs.chapterui.Chapter(@ui)

    d: ->
        @ui.battleStatsPanel.hide()
        @playerTurn.selectedUnit.inventory.refresh()
        @playerTurn.handleSkill(false)
        
        @ui.cursor.visible = false
        @ui.cursor.pos = @playerTurn.selectedUnit.pos.clone()
        @ui.unitInfoBox.update()

    skillDone: (exp=null) =>
        afterExpAdd = =>
            @ui.controlState = new _cs.chapterui.Map(@ui)
            @ui.cursor.visible = true
            @ui.unitInfoBox.update()
            @ui.terrainBox.show()
            @playerTurn.selectedUnit.setDone()
            @playerTurn.selectedUnit = null

        if not exp?
            exp = @skill.getExp()

        _turn.addExp(@ui, afterExpAdd, @playerTurn.selectedUnit, exp)


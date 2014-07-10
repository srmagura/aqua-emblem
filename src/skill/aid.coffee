class _skill.AidSkill extends _skill.Skill

    constructor: ->
        super()
        @overlayType = 'AID'
        @controlState = _cs.cui.AidSkill

    getDelta: (user) -> {}
    doEffect: (target) ->

class _cs.cui.AidSkill extends _cs.cui.Skill

    f: ->
        unit = @playerTurn.selectedUnit
        target = @ui.chapter.getUnitAt(@ui.cursor.pos)

        if not (target? and @skill.isValidTarget(target))
            return

        dist = unit.pos.distance(target.pos)
        if dist > @skill.range.max
            return

        super()

        delta = @skill.getDelta(unit)

        afterAction = =>
            @skill.doEffect(target)
            @skillDone()

        if unit is target
            action = new _enc.UnitAction(@ui, unit)
            action.doAction(@skill, afterAction, delta)
        else
            encounter = new _enc.AidEncounter(@ui, unit, target)
            encounter.doEncounter(afterAction, @skill, delta)


# DEFEND
class _skill.Defend extends _skill.AidSkill

    constructor: ->
        super()
        @name = 'Defend'
        @imageName = 'defend'
        @desc = 'During the next enemy turn, ' +
        'damage received is halved, but the unit cannot counterattack.'

        @mp = 2
        @range = new Range(0)

    doEffect: (target) ->
        target.addStatus(new _status.Defend())


class _skill.FirstAid extends _skill.AidSkill

    constructor: ->
        super()
        @name = 'First aid'
        @imageName = 'first_aid'
        @type = _skill.type.Holy
        @desc = 'Basic healing skill.'

        @mp = 4
        @might = 10
        @range = new Range(0, 1)

    getDelta: (user) ->
        return {hp: user.mag + @might}

    isValidTarget: (target) ->
        return target.hp < target.maxHp


class _skill.Temper extends _skill.AidSkill

    constructor: ->
        super()
        @name = 'Temper'
        @imageName = 'temper'
        @type = _skill.type.None
        @desc = 'Temporarily buff an ally\'s strength.'

        @mp = 9
        @range = new Range(0, 1)

    doEffect: (target) ->
        target.addStatus(new _status.Buff('str', 3))


class _skill.Protect extends _skill.AidSkill

    constructor: ->
        super()
        @name = 'Protect'
        @imageName = 'protect'
        @type = _skill.type.None
        @desc = 'Temporarily buff an ally\'s defence.'

        @mp = 1
        @range = new Range(0, 1)

    doEffect: (target) ->
        target.addStatus(new _status.Buff('def', 3))
class _skill.AidSkill extends _skill.Skill

    constructor: ->
        super()
        @overlayType = 'AID'
        @controlState = _cs.cui.AidSkill

    getDelta: (user) -> {}
    doEffect: (target) ->

class _cs.cui.AidSkill extends _cs.cui.Skill

    f: ->
        result = @getUserTarget()

        if result is false
            return
        else
            user = result.user
            target = result.target

        super()

        delta = @skill.getDelta(user)

        afterAction = =>
            @skill.doEffect(target)
            @skillDone()

        if user is target
            action = new _enc.UnitAction(@ui, user)
            action.doAction(@skill, afterAction, delta)
        else
            encounter = new _enc.AidEncounter(@ui, user, target)
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
        @type = new _skill.type.Holy()
        @desc = 'Basic healing skill.'

        @mp = 3
        @might = 20
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
        @desc = 'Temporarily buff an ally\'s strength and magic.'

        @mp = 4
        @range = new Range(0, 1)

    doEffect: (target) ->
        target.addStatus(new _status.Buff('str', 3))
        target.addStatus(new _status.Buff('mag', 3))


class _skill.Protect extends _skill.AidSkill

    constructor: ->
        super()
        @name = 'Protect'
        @imageName = 'protect'
        @desc = 'Temporarily buff an ally\'s defence and resistance.'

        @mp = 4
        @range = new Range(0, 1)

    doEffect: (target) ->
        target.addStatus(new _status.Buff('def', 3))
        target.addStatus(new _status.Buff('res', 3))

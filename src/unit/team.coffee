window._team = {}

class _team.Team
    
    constructor: (@units) ->
        for unit in @units
            unit.setTeam(this)

class _team.PlayerTeam extends _team.Team
    constructor: (@units, attr={}) ->
        for unit in @units
            if 'skills' not of unit
                unit.skills = []

            unit.skills = [new _skill.Defend()].concat(unit.skills)

        super(@units)

class _team.EnemyTeam extends _team.Team
    constructor: (@units, attr={}) ->
        for unit in @units
            if 'aiType' not of unit
                unit.aiType = _unit.AI_TYPE.NORMAL

            if 'defaultName' of attr and not unit.name?
                unit.setName(attr.defaultName)

        super(@units)

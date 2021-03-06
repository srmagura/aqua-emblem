window._team = {}

class _team.Team
    
    constructor: (@units) ->
        for unit in @units
            unit.setTeam(this)
            
    # Should only be used before Chapter has been created
    addUnit: (unit) ->
        @units.push(unit)
        unit.setTeam(this)


class _team.PlayerTeam extends _team.Team

    constructor: (@units) ->
        for unit in @units
            @initPlayerUnit(unit)

        super(@units)
   
    addUnit: (unit) ->
        super(unit)
        @initPlayerUnit(unit)
        
    initPlayerUnit: (unit) ->
        unit.allSkills = [{level: 1, skill: new _skill.Defend()}].concat(unit.allSkills)        
        
    pickle: ->
        array = []
        for unit in @units
            array.push(unit.pickle())
            
        return array
        
    @unpickle: (pickled) ->
        if not pickled instanceof Array
            return null
            
        units = []
        for pickledUnit in pickled
            unit = _unit.Unit.unpickle(pickledUnit)
            
            if unit is null
                return null
            else 
                units.push(unit)
                       
        return new _team.PlayerTeam(units)
        

class _team.EnemyTeam extends _team.Team

    insigniaImagePath: 'images/bandit_insignia.png'

    constructor: (@units, attr={}) ->
        if 'reinforcements' of attr
            @reinforcements = attr.reinforcements
        else
            @reinforcements = []
            
        if 'defaultAiType' not of attr
            attr.defaultAiType = _unit.aiType.normal
            
        for unit in @reinforcements
            unit.setTeam(this)
    
        for unit in @units.concat(@reinforcements)
            if 'aiType' not of unit
                unit.aiType = attr.defaultAiType
                
            if 'aiOptions' not of unit
                unit.aiOptions = {}
                
            if 'defaultName' of attr and not unit.name?
                unit.setName(attr.defaultName)
                
            if 'defaultLevel' of attr and not unit.level?
                if unit.dld?
                    dld = unit.dld
                else
                    dld = 0
                    
                unit.level = attr.defaultLevel + dld
                delete unit.dld
                
            for item in unit.inventory.it()
                item.uses = null
                
            unit.calcStatsInitial()

        super(@units)

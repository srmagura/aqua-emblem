class _cs.cui.AttackSkill extends _cs.cui.Skill

    constructor: (@ui, @playerTurn, @skill) ->
        super(@ui, @playerTurn, @skill)

        user = @playerTurn.selectedUnit
        spots = @playerTurn.getActionRange(user.pos, @skill.range)

        for spot in spots
            target = @ui.chapter.getUnitAt(spot)

            if target? and @skill.isValidTarget(target)
                @ui.cursor.moveTo(spot)
                break
                
        @moved()

    moved: ->
        result = @getUserTarget()

        if result is false
            @battle = null
            @ui.battleStatsPanel.hide()
        else
            user = result.user
            target = result.target

            user.equipped = @skill
            @battle = new _enc.Battle(@ui, user, target)
            @ui.battleStatsPanel.init(@battle)
            
         @playerTurn.setSkillOverlay(@skill)
         area = @skill.getEffectArea(@ui.chapter.map, @ui.cursor.pos)

         if area?
            for pos in area
                @ui.chapter.map.setOverlay(pos, 'DAMAGE')

    f: ->
        callback = =>
            @playerTurn.selectedUnit.inventory.refresh()
            exp = @battle.getExpToAdd()
            @skillDone(exp)

        super()
        @ui.battleStatsPanel.hide()
        @battle.doEncounter(callback)
        @battle.showSkillMessage(@skill)
        
        
class _skill.AttackSkill extends _skill.Skill

    constructor: ->
        super()
        @crit = 0
        @nAttackMultiplier = 1
        @controlState = _cs.cui.AttackSkill

    isValidTarget: (target) ->
        return target.team instanceof _team.EnemyTeam
        
    hasUses: (x) -> true
    
    getEffectArea: (pos) -> null


class _skill.Flare extends _skill.AttackSkill

    constructor: ->
        super()
        @overlayType = 'ATTACK'
        @type = new _skill.type.Dark()

        @name = 'Flare'
        @imageName = 'flare'
        @desc = 'Launch a wave of fire from your sword.'

        @mp = 4

        @hit = 90
        @might = 5
        @crit = 10
        @weight = 6
        @range = new Range(1, 2)
        
        
class _skill.SwordRain extends _skill.AttackSkill

    constructor: ->
        super()
        @overlayType = 'ATTACK'
        @type = new _skill.type.Sword()

        @name = 'Sword Rain'
        @imageName = 'sword_rain'
        @desc = 'Hit four times in a row.'

        @mp = 10

        @hit = 70
        @might = 3
        @weight = Infinity
        @range = new Range(1)
        @nAttackMultiplier = 4
        
class _skill.Meteor extends _skill.AttackSkill

    constructor: ->
        super()
        @overlayType = 'ATTACK'
        @type = new _skill.type.Dark()

        @name = 'Meteor'
        @imageName = 'meteor'
        @desc = 'Damage is centered on the target, ' +
        'but adjacent enemies also take damage.'

        @mp = 2

        @hit = 70
        @might = 3
        @weight = Infinity
        @range = new Range(1, 3)
        
    getEffectArea: (map, pos) ->
        rawArea = [
            pos,
            new Position(pos.i+1, pos.j),
            new Position(pos.i-1, pos.j),
            new Position(pos.i, pos.j+1),
            new Position(pos.i, pos.j-1),
        ]
        
        area = []
        for pos1 in rawArea
            if map.onMap(pos1)
                area.push(pos1)
                
        return area

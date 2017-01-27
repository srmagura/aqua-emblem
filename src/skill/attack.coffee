class _cs.chapterui.AttackSkill extends _cs.chapterui.Skill

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

    f: ->
        callback = =>
            @playerTurn.selectedUnit.inventory.refresh()
            exp = @battle.getExpToAdd()
            @skillDone(exp)

        if @battle is null
            return

        super()
        @ui.battleStatsPanel.hide()
        
        @battle.doEncounter(callback)
        
        
class _skill.AttackSkill extends _skill.Skill

    constructor: ->
        super()
        @crit = 0
        @nAttackMultiplier = 1
        @controlState = _cs.chapterui.AttackSkill
        @overlayType = 'ATTACK'

    isValidTarget: (target) ->
        return target? and target.team instanceof _team.EnemyTeam
        
    hasUses: (x) -> true


class _skill.Flare extends _skill.AttackSkill

    constructor: ->
        super()
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
        @type = new _skill.type.Sword()

        @name = 'Sword Rain'
        @imageName = 'sword_rain'
        @desc = 'Hit four times in a row.'

        @mp = 6

        @hit = 70
        @might = 3
        @weight = Infinity
        @range = new Range(1)
        @nAttackMultiplier = 4
        
class _skill.Meteor extends _skill.AttackSkill

    constructor: ->
        super()
        @type = new _skill.type.Dark()

        @name = 'Meteor'
        @imageName = 'meteor'
        @desc = 'Medium-range dark magic.'

        @mp = 10

        @hit = 70
        @might = 13
        @weight = Infinity
        @range = new Range(1, 4)

       
class _skill.PoisonArrow extends _skill.AttackSkill

    constructor: ->
        super()
        @type = new _skill.type.Bow()

        @name = 'Poison Arrow'
        @imageName = 'poison_arrow'
        @desc = 'Poisons the target.'

        @mp = 2

        ironBow = new _item.IronBow()
        @hit = ironBow.hit
        @might = 2
        @weight = ironBow.weight
        @range = new Range(2)
        
    getStatusEffect: (data) ->
        return new _status.Poison(data.battle.atk.battleStats.dmg)

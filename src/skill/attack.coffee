class _cs.cui.AttackSkill extends _cs.cui.Skill

    constructor: (@ui, @playerTurn, @skill) ->
        super(@ui, @playerTurn, @skill)

        user = @playerTurn.selectedUnit
        spots = @playerTurn.getActionRange(user.pos, @skill.range)

        for spot in spots
            target = @ui.chapter.getUnitAt(spot)

            if target? and @skill.isValidTarget(target)
                @ui.cursor.moveTo(spot)
                @moved()
                break

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
        super()

class _skill.Flare extends _skill.Skill

    constructor: ->
        super()
        @overlayType = 'ATTACK'
        @type = new _skill.type.Dark()

        @name = 'Flare'
        @imageName = 'flare'
        @desc = 'Launch a wave of fire from your sword.'

        @mp = 4

        @hit = 90
        @might = 4
        @crit = 10
        @weight = 10
        @range = new Range(1, 2)

        @controlState = _cs.cui.AttackSkill

    isValidTarget: (target) ->
        return target.team instanceof _team.EnemyTeam

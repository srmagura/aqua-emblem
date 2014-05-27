class window.BattleStatsPanel

    constructor: (@ui) ->
        @panel = $('.battle-stats-panel')

    init: (battle) ->
        fillHalf = (unit, unitName) =>
            @panel.find(".#{unitName}-name").text(unit.name)

            for statType in ['hit', 'dmg', 'crt']
                value = unit.battleStats[statType]

                if value?
                    value = Math.round(value)
                else
                    value = '--'

                @panel.find(".#{unitName}-#{statType}").text(value)

        fillHalf(battle.atk, 'attacker')
        fillHalf(battle.def, 'defender')
        @show()

    show: ->
        @panel.css('display', 'inline-block')

    hide: ->
        @panel.css('display', 'none')

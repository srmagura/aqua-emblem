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

                td = @panel.find(".#{unitName}-#{statType}")
                td.find('.stat').text(value)

                if statType == 'dmg' and
                battle.nTurns[unitName] == 2
                    td.find('.x2').show()

        fillHalf(battle.atk, 'atk')
        fillHalf(battle.def, 'def')
        @show()

    show: ->
        @panel.css('display', 'inline-block')

    hide: ->
        @panel.css('display', 'none')

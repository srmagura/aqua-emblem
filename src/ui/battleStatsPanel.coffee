class window.BattleStatsPanel

    constructor: (@ui) ->
        @panel = $('.battle-stats-panel')

    init: (battle) ->
        @panel.find('.attacker-name').
            text(battle.atk.name)
        @panel.find('.attacker-hit').
            text(Math.round(battle.atk.battleStats.hit))
        @panel.find('.attacker-dmg').
            text(Math.round(battle.atk.battleStats.dmg))
        @panel.find('.attacker-crt').
            text(Math.round(battle.atk.battleStats.crt))

        @panel.find('.defender-name').
            text(battle.def.name)
        @panel.find('.defender-hit').
            text(Math.round(battle.def.battleStats.hit))
        @panel.find('.defender-dmg').
            text(Math.round(battle.def.battleStats.dmg))
        @panel.find('.defender-crt').
            text(Math.round(battle.def.battleStats.crt))

        @show()

    show: ->
        @panel.css('display', 'inline-block')

    hide: ->
        @panel.css('display', 'none')

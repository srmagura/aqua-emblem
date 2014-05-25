class window.BattleStatsPanel

    constructor: (@ui) ->
        @panel = $('.battle-stats-panel')

    init: (battle) ->
        @panel.find('.attacker-name').
            text(battle.atk.name)
        @panel.find('.attacker-hit').
            text(battle.atk.battleStats.hit)
        @panel.find('.attacker-dmg').
            text(battle.atk.battleStats.dmg)
        @panel.find('.attacker-crt').
            text(battle.atk.battleStats.crt)

        @panel.find('.defender-name').
            text(battle.def.name)
        @panel.find('.defender-hit').
            text(battle.def.battleStats.hit)
        @panel.find('.defender-dmg').
            text(battle.def.battleStats.dmg)
        @panel.find('.defender-crt').
            text(battle.def.battleStats.crt)

        @show()

    show: ->
        @panel.css('display', 'inline-block')

    hide: ->
        @panel.css('display', 'none')

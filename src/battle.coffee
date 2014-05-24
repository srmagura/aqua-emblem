class window.Battle

    constructor: (@ui, @atk, @def) ->
        @calcBattleStats()

    calcBattleStats: (playerWeapon) ->
        if playerWeapon?
            @calcIndividual(@atk, playerWeapon, @def)
        else
            @calcIndividual(@atk, @atk.equipped, @def)

        @calcIndividual(@def, @def.equipped, @atk)
        @turns = [@atk, @def]

    calcIndividual: (unit1, weapon1, unit2) ->
        unit1.battleStats = {hit: 100}
        unit1.battleStats.dmg = unit1.str + weapon1.might - unit2.def

    setPlayerWeapon: (weapon) ->
        @calcBattleStats(weapon)

    doBattle: (callback) ->


class _cui.BattleStatsPanel

    constructor: (@ui) ->
        @panel = $('.battle-stats-panel')

    init: (battle) ->
        fillHalf = (unit, unitName) =>
            nameCell = @panel.find(".#{unitName}-name")
            nameCell.find('span').text(unit.name)

            imgSrc = unit.equipped.getImagePath()
            nameCell.find('img.weapon').attr('src', imgSrc)

            if unit.advantage is true
                imgSrc = "images/up_arrow.png"
            else if unit.advantage is false
                imgSrc = "images/down_arrow.png"
            else
                imgSrc = null

            img = nameCell.find('img.weapon-arrow')
            if imgSrc?
                img.attr('src', imgSrc).show()
            else
                img.hide()

            for statType in ['hp', 'hit', 'dmg', 'crt']
                if statType is 'hp'
                    value = unit.hp
                else
                    value = unit.battleStats[statType]

                if value?
                    value = Math.round(value)
                else
                    value = '---'

                td = @panel.find(".#{unitName}-#{statType}")
                td.find('.stat').text(value)

                if statType == 'dmg' and
                battle.nTurns[unitName] == 2
                    td.find('.x2').show()
                else
                    td.find('.x2').hide()

        fillHalf(battle.atk, 'atk')
        fillHalf(battle.def, 'def')
        @show()

    show: ->
        @panel.css('display', 'inline-block')

    hide: ->
        @panel.css('display', 'none')

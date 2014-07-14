class _cui.ItemInfoBox

    constructor: (@ui, @box) ->

    init: (item, canUse) ->
        @box.find('.header').html(item.getElement(canUse))

        weaponStatsEl = @box.find('.weapon-stats')
        weaponStats = ['hit', 'might', 'crit', 'weight']
        for stat in weaponStats
            weaponStatsEl.find('.' + stat).text(item[stat])

        @show()

    show: -> @box.show()
    hide: -> @box.hide()

class _chapterui.ItemInfoBox

    constructor: (@ui, @box) ->

    init: (item, usable) ->
        options = {usable: usable}
        @box.find('.header').html(item.getElement(options))

        weaponStatsEl = @box.find('.weapon-stats')
        weaponStats = ['hit', 'might', 'crit', 'weight']
        for stat in weaponStats
            weaponStatsEl.find('.' + stat).text(item[stat])

        weaponStatsEl.find('.range').text(item.range.toString())
        @show()

    show: -> @box.show()
    hide: -> @box.hide()

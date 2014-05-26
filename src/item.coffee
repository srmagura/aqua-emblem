window.ITEM_TYPE = {
    WEAPON: 0
}

window.WEAPON_TYPE = {
    SWORD: {image: 'steel_sword.png'},
    BOW: {image: 'iron_bow.png'}
}

allItems = {
    'iron-sword': {itemType: ITEM_TYPE.WEAPON,
    weaponType: WEAPON_TYPE.SWORD,
    name: 'Iron sword', hit: 85, might: 4, weight: 2, crit: 0},

    'iron-bow': {itemType: ITEM_TYPE.WEAPON,
    weaponType: WEAPON_TYPE.BOW,
    name: 'Iron bow', hit: 85, might: 4, weight: 2, crit: 0}
}

class window.Item
    constructor: (@itemId) ->
        for key, value of allItems[itemId]
            this[key] = value

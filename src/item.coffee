window.ITEM_TYPE = {
    WEAPON: 0
}

window.WEAPON_TYPE = {
    SWORD: 0
}

allItems = {
    'iron-sword': {itemType: ITEM_TYPE.WEAPON,
    weaponType: WEAPON_TYPE.SWORD,
    name: 'Iron sword', might: 4}
}

class window.Item
    constructor: (@itemId) ->
        for key, value of allItems[itemId]
            this[key] = value

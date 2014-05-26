window.item = {}

class item.Item

    constructor: ->
        @fudge = 1

class item.Weapon extends item.Item

    constructor: ->

class item.Sword extends item.Weapon

    constructor: ->
        @image = 'steel_sword.png'
        @range = [1]

class item.IronSword extends item.Weapon

    constructor: ->
        @name = 'Iron sword'
        @hit = 85
        @might = 4
        @weight = 2
        @crit = 0

class item.Bow extends item.Weapon

    constructor: ->
        @image = 'iron_bow.png'
        @range = [2]

class item.IronBow extends item.Weapon

    constructor: ->
        @name = 'Iron bow'
        @hit = 85
        @might = 4
        @weight = 2
        @crit = 0

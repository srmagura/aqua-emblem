window.skill = {}

skill.type = {
    NONE: 0,
}

class skill.Skill

    constructor: ->
        @type = skill.type.NONE
        @might = null
        @mp = 0

    getImagePath: ->
        return "images/skills/#{@imageName}.png"

class skill.Defend extends skill.Skill

    constructor: ->
        super()
        @name = 'Defend'
        @imageName = 'defend'
        @desc = 'During the next enemy turn, ' +
        'damage received is halved, but the unit cannot counterattack.'
        @cooldown = 1

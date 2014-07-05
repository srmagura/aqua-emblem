class _enc.AidEncounter extends _enc.Encounter

    doEncounter: (@callback, @skill, @delta) ->
        super(@callback)

    doAction: =>
        @atk.mp -= @skill.mp
        if 'hp' of @delta
            @def.addHp(@delta.hp)

        message = @skill.getMessageEl()
        message.addClass('blue-box').appendTo(@container)

        afterFadeIn = =>
            @doLunge(@atk)
            @atkBox.init(@atk, true)
            @defBox.init(@def, true)
            setTimeout(afterDelay, @delay*4/3)

        afterDelay = =>
            @container.fadeOut(@delay/3)
            message.fadeOut(@delay/3, @encounterDone)

        message.fadeIn(@delay/3, afterFadeIn)

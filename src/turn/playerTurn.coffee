class _turn.PlayerTurn extends _turn.Turn

    constructor: (@ui) ->
        super(@ui)
        @tradeRange = new Range(1)

    select: (unit) ->
        @origin0 = @ui.origin.clone()

        @available = @getAvailable(unit)
        attackRange = @movementGetAttackRange(@available, unit)

        for spot in attackRange
            @ui.chapter.map.setOverlay(spot.targetSpot, 'ATTACK')

        for spot in @available
            @ui.chapter.map.setOverlay(spot.pos, 'AVAILABLE')


        if unit.team instanceof _team.PlayerTeam
            @selectedUnit = unit
            @dest = new _map.Destination()
            @updateDestination()
        else
            @selectedEnemy = unit
            @ui.controlState = new _cs.cui.EnemySelected(@ui)

    deselect: ->
        if @selectedUnit
            @ui.origin = @origin0
            @ui.cursor.pos = @selectedUnit.pos.clone()

        @selectedUnit = null
        @selectedEnemy = null
        @dest = null
        @ui.chapter.map.clearOverlay()


    updateDestination: ->
        cp = @ui.cursor.pos
        if @ui.chapter.map.overlayTiles[cp.i][cp.j] is
        _map.OVERLAY_TYPES.AVAILABLE and @selectedUnit?
            @dest.pos = cp.clone()

            for spot in @available
                if spot.pos.equals(cp)
                    @dest.path = spot.path
                    break

    initMove: ->
        unitAtDest = @ui.chapter.getUnitAt(@dest.pos)
        if unitAtDest isnt null and unitAtDest isnt @selectedUnit
            return

        @selectedUnit.oldPos = @selectedUnit.pos
        @ui.chapter.map.clearOverlay()
        @ui.cursor.visible = false
        @ui.controlState = new _cs.cui.Chapter(@ui)

        @selectedUnit.followPath(@dest.path, @afterPathFollow)
        @dest = null

    afterPathFollow: =>
        @ui.unitInfoBox.init(@selectedUnit, false, true)
        @ui.unitInfoBox.show()

        @initActionMenu()

    initActionMenu: =>
        attackRange = @getAttackRange(@selectedUnit, @selectedUnit.pos)
        @inAttackRange = []

        for obj in attackRange
            target = @ui.chapter.getUnitAt(obj.targetSpot)
            if target? and target.team isnt @selectedUnit.team
                @inAttackRange.push(target)

        @inTradeRange = []
        for pos in @getActionRange(@selectedUnit.pos, @tradeRange)
            target = @ui.chapter.getUnitAt(pos)
            if target? and target.team is @selectedUnit.team
                @inTradeRange.push(target)

        actions = []

        if @inAttackRange.length != 0
            actions.push(new _chapterui.ActionMenuItem('Attack', @handleAttack))

        actions.push(new _chapterui.ActionMenuItem('Skill', @handleSkill))
            
        if @inTradeRange.length != 0
            actions.push(new _chapterui.ActionMenuItem('Trade', @handleTrade))

        if @selectedUnit.inventory.size() != 0
            actions.push(new _chapterui.ActionMenuItem('Items', @handleItems))
            
        actions.push(new _chapterui.ActionMenuItem('Wait', @handleWait))
        @ui.actionMenu.init(@selectedUnit, actions)

    handleWait: =>
        @ui.cursor.visible = true
        @selectedUnit.setDone()
        @deselect()
        
    handleItems: =>
        @ui.itemMenu.init({playerTurn: this})

    handleAttack: =>
        @ui.actionMenu.hide()
        @ui.weaponMenu.init(this)

    handleSkill: (resetCursor=true) =>
        @ui.skillsBox.resetCursor = resetCursor
        @ui.skillsBox.init(@selectedUnit, @skillsBoxOnD,
        @skillsBoxOnCursorMove)
        @ui.skillsBox.onF = @skillsBoxOnF
        @ui.skillsBox.giveControl(resetCursor)

    skillsBoxOnD: =>
        @ui.skillsBox.hide()
        @ui.actionMenu.init(@selectedUnit)

    skillsBoxOnF: =>
        skill = @ui.skillsBox.getSkill()

        if not @selectedUnit.canUseSkill(skill)
            return

        @ui.skillsBox.hide()
        @ui.skillInfoBox.init(skill, true, false)
        @ui.controlState = skill.getControlState(@ui, this)
        @ui.cursor.visible = true

    skillsBoxOnCursorMove: =>
        skill = @ui.skillsBox.getSkill()
        
        if @selectedUnit.mp < skill.mp
            @ui.chapter.map.clearOverlay()
        else
            @setSkillOverlay(skill)
        
    setSkillOverlay: (skill) ->
        @ui.chapter.map.setOverlayRange(@selectedUnit.pos,
            skill.range, skill.overlayType)

    handleTrade: =>
        @ui.chapter.map.setOverlayRange(@selectedUnit.pos, @tradeRange, 'AID')
        @ui.controlState = new _cs.cui.ChooseTradeTarget(@ui, this)
        @ui.cursor.visible = true
        @ui.cursor.moveTo(@inTradeRange[0].pos)

    afterExpAdd: =>
        @ui.controlState = new _cs.cui.Map(@ui)
        @ui.cursor.visible = true
        @ui.cursor.moveTo(@selectedUnit.pos)

        @selectedUnit.setDone()
        @selectedUnit = null


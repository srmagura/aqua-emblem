# Abstract classes for control states
# A control state is an object that handles key presses
#
# The control state depends on the context:
# For example, while viewing the map, the arrow keys move the cursor
# But while viewing a menu, the up/down arrow keys change the selected
# option, and left/right do nothing

window._cs = {}

class _cs.ControlState
    # Extremely abstract class. Override methods to handle inputs as desired.

    constructor: (@ui) ->
    up: ->
    down: ->
    left: ->
    right: ->
    f: ->
    d: ->
    s: ->
    e: ->
    v: ->

class _cs.Menu extends _cs.ControlState
    # Abstract control state class for all menus.
    # Up and down change the selected option

    constructor: (@ui, @menuObj) ->

    onChange: ->

    up: ->
        # Currently selected object is no longer selected
        sel = @menuObj.menu.find('.selected')
        sel.removeClass('selected')

        # Try to move up. If we are already at the first option,
        # loop around to the last option
        if sel.prev().size() != 0
            sel.prev().addClass('selected')
        else
            @menuObj.menu.children('div').last().
                addClass('selected')

        @onChange()

    down: ->
        # Currently selected object is no longer selected
        sel = @menuObj.menu.find('.selected')
        sel.removeClass('selected')

        # Try to move down. If we are already at the last option,
        # loop around to the first option
        if sel.next().size() != 0
            sel.next().addClass('selected')
        else
            @menuObj.menu.children('div').first().
                addClass('selected')

        @onChange()

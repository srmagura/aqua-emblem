# controlState for menus within a chapter
# behaves like a normal menu. But if the user presses v,
# toggle 3x speed

class _cs.chapterui.Menu extends _cs.Menu

    constructor: (@ui, @menuObj) ->
        @chapterCs = new _cs.chapterui.Chapter(@ui)

    v: -> @chapterCs.v()

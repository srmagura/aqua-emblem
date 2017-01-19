class _cs.cui.Menu extends _cs.Menu

    constructor: (@ui, @menuObj) ->
        @chapterCs = new _cs.cui.Chapter(@ui)

    v: -> @chapterCs.v()

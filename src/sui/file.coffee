window._file = {}
_file.fs = {}

_file.difficulty = {
    normal: {statBonus: 1, expMultiplier: 4/3},
    hard: {statBonus: 0, expMultiplier: 1}
}

class _file.File
    
    constructor: ->

    setFileState: (fsCls) ->
        @fileState = new fsCls(this)

    init: ->
        @fileState.init()


class _file.FileState
    constructor: (@file) ->
